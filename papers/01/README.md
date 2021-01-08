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








## Takeaways

1. I was struck as I read this paper, how often the author referenced other vulns/exploits as idea fodder for his next step or as a means of getting un-stuck. This really drove home to me the value of reading and deeply understanding existing attacks/vulns.

