; adapted from asmtutor.com
; run make to compile and link

SECTION .data
    msg db  'Hello, brave new world!', 0Ah

SECTION .text
    global _start

_start:

    mov ebx, msg        ; move the address of our message string into EBX
    call strlen         ; call our function to calculate the length of the string


    mov edx, eax        ; Our function leaves the result in EAX
    mov ecx, msg        ; the rest is the same as before
    mov ebx, 1
    mov eax, 4
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h

strlen:                 ; this is our first function declaration
    push ebx            ; push the value in EBX onto th4e stack to preserve it while we use EBX in this func
    mov eax, ebx        ; move the address in EBX into EAX as well (both now point ot the same spot)

nextchar:               ; same as before
    cmp byte [eax], 0
    jz finished
    inc eax
    jmp nextchar

finished:
    sub eax, ebx
    pop ebx             ; pop the value on the stack back into EBX
    ret;                ; return to where the function was called
    