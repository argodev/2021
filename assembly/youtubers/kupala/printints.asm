
section .bss
    digitSpace resb 100         ; reserve 100 bytes to hold the digits
    digitSpacePos resb 8        ; 

section .text
    global _start

; logic:
; 123/10 = 12 remainder 3
; when we div, rdx gets the remainder


_start:
    mov rax, 123
    call _printRAX

    ; exit
    mov rax, 60
    mov rdi, 0
    syscall

_printRAX:
    ; build the string backwards
    mov rcx, digitSpace
    mov rbx, 10     ; LF
    mov [rcx], rbx
    inc rcx
    mov [digitSpacePos], rcx

_printRAXLoop:
    mov rdx, 0
    mov rbx, 10
    div rbx
    push rax
    add rdx, 48                     ; convert to ascii char

    mov rcx, [digitSpacePos]
    mov [rcx], dl                   ; lower 8 bytes of rdx... get the char we just converted to
    inc rcx
    mov [digitSpacePos], rcx

    pop rax
    cmp rax, 0
    jne _printRAXLoop

_printRAXLoop2:
    mov rcx, [digitSpacePos]
    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, 1
    syscall

    mov rcx, [digitSpacePos]
    dec rcx
    mov [digitSpacePos], rcx

    cmp rcx, digitSpace
    jge _printRAXLoop2

    ret