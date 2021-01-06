%include "linux64.inc"

section .data
    filename db "myfile.txt",0

section .bss
    text resb 18

section .text
    global _start

_start:

    ; opening a file for reading
    mov rax, SYS_OPEN
    mov rdi, filename
    mov rsi, O_RDONLY
    mov rdx, 0              ; don't think I need this
    syscall

    ; reading from a file
    push rax                    ; store FD on stack for later use
    mov rdi, rax                ; file descriptor was stored in rax from prior op
    mov rax, SYS_READ
    mov rsi, text
    mov rdx, 17
    syscall

    ; closing a file
    mov rax, SYS_CLOSE
    pop rdi
    syscall

    print text
    exit
