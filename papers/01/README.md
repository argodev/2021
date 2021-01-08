# Week 01: An iOS hacker tries Android

* [Paper Link](https://googleprojectzero.blogspot.com/2020/12/an-ios-hacker-tries-android.html)
* [Targeted Bugs](https://bugs.chromium.org/p/project-zero/issues/detail?id=2073)
* [Exploit Code](https://bugs.chromium.org/p/project-zero/issues/detail?id=2073#c1)
* [NPU Definition](https://www.samsung.com/global/galaxy/what-is/npu/)
* [Samsung Open Source](https://opensource.samsung.com/uploadSearch?searchValue=sm-g973f)

Author's Objective: Given two known/documented vulnerabilities in a kernel driver for Android, could he turn those into a full-blown kernel exploit (he previously only had experience with iOS).

I read through the paper once and tried to wrap my head around what was going on, and what the author was trying to communicate. I think I got the general gist, but took another pass to gather more info.

One key is to consider the attack surface, which in this case it the _kernel_. So, the attacker is a malicous application (not remote), who is attempting to manipulate the kernel and thereby accomplish things it shouldn't be able to do otherwise (e.g. change perms, read sensitive data from other apps, etc.). This means (stating the obvious here), that the attacker has full access to the normal APIs available on the system.

## Bugs

The bugs used in this paper weren't the main story (found and reported by someone else), however I find it important to work to understand the bugs as I'm trying to improve my _spotting_ abilities. This also helps me think through what is going on.


The first issue pointed out is an unvalidated, attacker-controlled counter that is used to loop through memory. This means that a.) the attacker could provide a completely bogus value and cause the kernel to read well beyond what was actually provided.  The releveant code snippet is as follows:

```c
int __pilot_parsing_ncp(struct npu_session *session, u32 *IFM_cnt, u32 *OFM_cnt, u32 *IMB_cnt, u32 *WGT_cnt)
{
	int ret = 0;
	u32 i = 0;
	char *ncp_vaddr;
	u32 memory_vector_cnt;
	u32 memory_vector_offset;
	struct memory_vector *mv;
	struct ncp_header *ncp;

	ncp_vaddr = (char *)session->ncp_mem_buf->vaddr;
	ncp = (struct ncp_header *)ncp_vaddr;
	memory_vector_offset = ncp->memory_vector_offset;
	memory_vector_cnt = ncp->memory_vector_cnt;
	mv = (struct memory_vector *)(ncp_vaddr + memory_vector_offset);

	for (i = 0; i < memory_vector_cnt; i++) {
		u32 memory_type = (mv + i)->type;
		switch (memory_type) {
		case MEMORY_TYPE_IN_FMAP:
			{
				(*IFM_cnt)++;
				break;
			}
		case MEMORY_TYPE_OT_FMAP:
			{
				(*OFM_cnt)++;
				break;
			}
		case MEMORY_TYPE_IM_FMAP:
			{
				(*IMB_cnt)++;
				break;
			}
		case MEMORY_TYPE_CUCODE:
		case MEMORY_TYPE_WEIGHT:
		case MEMORY_TYPE_WMASK:
			{
				(*WGT_cnt)++;
				break;
			}
		}
	}
	return ret;
}
```

Here we see the `session` is passed in and used to set `ncp_vaddr` which is cast and used as `ncp`. `ncp` is then used to set `memory_vector_cnt` which is the controlling value on the `for()`. At no place is `memory_vector_cnt` checked or validated. Of course, all that is done by this function is the reading of data and then counting the number of each memory type and returning it. If the attacker uses a bad value, it could keep reading past the actual data and return inaccurate counts. Alternatively, it could read past valid memory and cause a kernel panic/crash.

This may be a problem, but where it really shows up as an issue is when you consider how `__pilot_parsing_ncp()` is used in context. Here, we see a snippet from `__config_session_info()`:

```c
int __config_session_info(struct npu_session *session)
{
	int ret = 0;
	u32 i = 0;
	u32 direction;

	u32 temp_IFM_cnt = 0;
	u32 temp_OFM_cnt = 0;
	u32 temp_IMB_cnt = 0;
	u32 WGT_cnt = 0;

	u32 IMB_cnt = 0;

	struct temp_av *temp_IFM_av;
	struct temp_av *temp_OFM_av;
	struct temp_av *temp_IMB_av;
	struct addr_info *WGT_av;
	struct npu_memory_buffer *IMB_mem_buf;

	ret = __pilot_parsing_ncp(session, &temp_IFM_cnt, &temp_OFM_cnt, &temp_IMB_cnt, &WGT_cnt);

	temp_IFM_av = kcalloc(temp_IFM_cnt, sizeof(struct temp_av), GFP_KERNEL);
	temp_OFM_av = kcalloc(temp_OFM_cnt, sizeof(struct temp_av), GFP_KERNEL);
	temp_IMB_av = kcalloc(temp_IMB_cnt, sizeof(struct temp_av), GFP_KERNEL);
	WGT_av = kcalloc(WGT_cnt, sizeof(struct addr_info), GFP_KERNEL);

	session->WGT_info = WGT_av;

	session->ss_state |= BIT(NPU_SESSION_STATE_WGT_KALLOC);

	ret = __second_parsing_ncp(session, &temp_IFM_av, &temp_OFM_av, &temp_IMB_av, &WGT_av);
	if (ret) {
		npu_uerr("fail(%d) in second_parsing_ncp\n", session, ret);
		goto p_err;
	}

    // REG: truncated code for clarity

p_err:
	kfree(temp_IFM_av);
	kfree(temp_OFM_av);
	kfree(temp_IMB_av);
	return ret;
}
```

Here we see that `__pilot_parsing_ncp()` is used to get the number of each memory type. These values are then used to allocate (via `kcalloc()`) memory for four different buffers which are then used by `__second_parsing_ncp()`.

> __But Wait!!!__ There is a key piece of information here that I haven't mentioned... the `session` object used above actually comes from an [ION buffer](https://lwn.net/Articles/480055/). This a a feature of the Android OS that allows memory to be shared between userspace and kernelspace _without_ requiring a copy. This means, that the user can read/write to the same memory that the kernel can.

Knowing this, if we then take a look at part of `__second_parsing_ncp()`...

```c
int __second_parsing_ncp(
	struct npu_session *session,
	struct temp_av **temp_IFM_av, struct temp_av **temp_OFM_av,
	struct temp_av **temp_IMB_av, struct addr_info **WGT_av)
{

    // Code Truncated for clarity

	char *ncp_vaddr;
	dma_addr_t ncp_daddr;

	ncp_vaddr = (char *)session->ncp_mem_buf->vaddr;
	ncp_daddr = session->ncp_mem_buf->daddr;
	ncp = (struct ncp_header *)ncp_vaddr;

    // Code Truncated for clarity


	memory_vector_cnt = ncp->memory_vector_cnt;

	IFM_cnt = &session->IFM_cnt;
	OFM_cnt = &session->OFM_cnt;
	IMB_cnt = &session->IMB_cnt;
	WGT_cnt = &session->WGT_cnt;

	*IFM_cnt = 0;
	*OFM_cnt = 0;
	*IMB_cnt = 0;
	*WGT_cnt = 0;

	for (i = 0; i < memory_vector_cnt; i++) {

        // Code Truncated for clarity

    }

p_err:
	return ret;
}
```

Here things start to get intersting. First, we see that `memory_vector_cnt` is initialized in the same way as before. However, since this is an ION buffer and shared with the attacker, it could have been updated in between the time that it was used for determining the size of/number of allocations to make and now. Additionally, the same is true for the four memory-type counts (e.g. `&session->IFM_cnt`). The author refers to this as a "TOCTOU" issue (time-of-check-to-time-of-use). 





## Takeaways

1. I was struck as I read this paper, how often the author referenced other vulns/exploits as idea fodder for his next step or as a means of getting un-stuck. This really drove home to me the value of reading and deeply understanding existing attacks/vulns.

