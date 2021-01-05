;
; simple program to show some simple math
;

section .data
    digit db 0,10       ; define variable named "digit", init to 0 + LineFeed

section .text
    global _start

_start:

    ; simple division
    mov rax, 6
    mov rbx, 2
    div rbx
    call _printRAXDigit

    ; addition
    mov rax, 1
    add rax, 4
    call _printRAXDigit

    ; playing with the stack
    push 4
    push 8
    push 3

    pop rax
    call _printRAXDigit
    pop rax
    call _printRAXDigit
    pop rax
    call _printRAXDigit

    ; exit with success
    mov rax, 60
    mov rdi, 0
    syscall

_printRAXDigit:
    add rax, 48
    mov [digit], al
    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, 2
    syscall
    ret