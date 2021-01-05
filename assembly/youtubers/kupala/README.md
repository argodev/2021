# Notes

```asm
section .data
    text db "Hello, World!", 10

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, text
    mov rdx, 14
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
```


`db` == define bytes, or "we're going to enter raw bytes here"

`text` in the `.data` section is defining a variable that can then be referenced by code within the `.text` section

![](../../../images/assembly_registers.png)
<sub><sup>Image credit kupala: https://www.youtube.com/watch?v=BWRR3Hecjao</sup></sub>

## System Call Inputs by Register

| Argument | Registers |
| -------- | --------- |
| ID | rax |
| 1 | rdi |
| 2 | rsi |
| 3 | rdx |
| 4 | r10 |
| 5 | r8 |
| 6 | r9 |

Examples of syscalls: `sys_read`, `sys_write`, `sys_open`, `sys_close`, etc.


## Sections

`.data` - global variables

`.text` - code goes here

`.bss` - reserve memory to use

Labels are used to label a part of code (see `_start:` above)

The `_start` label is important... it is what the OS looks to run first in the program


## Jumps, Calls, Comparisons

### Flags

| Symbol | Description |
| ------ | ----------- |
| CF | Carry |
| PF | Parity |
| ZF | Zero |
| SF | Sign |
| OF | Overflow |
| AF | Adjust |
| IF | Interrupt Enabled |

### Pointers

Similar to pointers in other language. Standard pointers include `rip` (instruction pointer), `rsp` (stack pointer), and `rbp` (stack base pointer)

### Control Flow

Just like you expect

### Jumps

Jumps to different parts of the code based on labels

`jmp <label>`

Effectively, this just loads the address of `<label>` into the `rip` register

### Comparisons

compares register to another register, or value

Flags, most noteably `zf` is set as a result of the comparison. If the values are equal, `zf = 1`. If not, `zf = 0`

Conditional jumps occur immediately after a comparison

`je` equal, `jne` not equal, `jg`, 

### Registers as pointers

Surrounding a register name with `[` square brackets `]`, it uses the value it is pointing to

```assembly
mov rax, [rbx]
```

### Calls

Similar to a jump, but the original location can be returned to you using `ret`. See the following modification that now looks like a function call or subroutine

```asm
section .data
    text db "Hello, World!", 10

section .text
    global _start

_start:
    call _printHello

    mov rax, 60
    mov rdi, 0
    syscall

_printHello:
    mov rax, 1
    mov rdi, 1
    mov rsi, text
    mov rdx, 14
    syscall

```


## Getting User Input

See [`userinput.asm`](userinput.asm)

