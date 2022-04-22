; adapted from asmtutor.com
; run make to compile and link

SECTION .data
    msg db  'Hello, world!', 0Ah     ; assign message variable with our message string

SECTION .text
    global _start

_start:

    mov edx, 14        ; eax now equals the number of bytes in our string
    mov ecx, msg
    mov ebx, 1
    mov eax, 4
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h
