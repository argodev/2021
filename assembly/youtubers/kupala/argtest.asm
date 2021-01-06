%include "linux64.inc"

section .data
    newline db 10,0

section .text
    global _start

_start:
    pop rax
    printVal rax
    print newline
    exit
