section .data
    text db "Hello, World!",10,0        ; ending with magic null byte that we will look for
    text2 db "world?",10,0

section .text
    global _start

_start:
    mov rax, text
    call _print

    mov rax, text2
    call _print

    mov rax, 60
    mov rdi, 0
    syscall

;input: rax as pointer to string
;output: print string at rax
_print:
    push rax
    mov rbx, 0          ; counter for len of string

    ; figure out the length of the provided string
_printLoop:
    inc rax
    inc rbx
    mov cl, [rax]       ; 8-bit equiv of rcx
    cmp cl, 0           ; if == 0, we are at the end of the string
    jne _printLoop      ; if not, keep going
    
    ; now we actually print it
    mov rax, 1
    mov rdi, 1
    pop rsi
    mov rdx, rbx
    syscall
    ret
