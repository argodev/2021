section .data
section .text

    global _start

_start:
    nop ; put your experiment lines in between the two nops

    mov ax, 0x67FE
    mov bx, ax
    mov cl, bh
    mov ch, bl

    nop

section .bss
