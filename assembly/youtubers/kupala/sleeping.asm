%include "linux64.inc"

section .data
    delay dq 5, 500000000

section .text
    global _start

_start:

    mov rax, SYS_NANOSLEEP
    mov rdi, delay
    mov rsi, 0
    syscall

    exit