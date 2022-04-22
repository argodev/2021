%include "linux64.inc"

section .data
    filename db "myfile.txt",0
    text db "Here's some text."

section .text
    global _start

_start:

    ; opening a file
    mov rax, SYS_OPEN
    mov rdi, filename
    mov rsi, O_CREAT+O_WRONLY
    mov rdx, 0644o
    syscall

    ; writing to a file
    push rax                    ; store FD on stack for later use
    mov rdi, rax                ; file descriptor was stored in rax from prior op
    ;pop rdi, rax                ; file descriptor was stored in rax from prior op
    mov rax, SYS_WRITE
    mov rsi, text
    mov rdx, 17
    syscall

    ; closing a file
    mov rax, SYS_CLOSE
    pop rdi
    syscall

    exit
