;  Executeable name : EATSYSCALL
;  Version          : 1.0
;  Created date     : 1/7/2009
;  Last update      : 1/22/2021
;  Author           : Jeff Duntemann
;  Updated By       : @argodev
;  Description      : A simple assembly app for Linux, using NASM 2.14.02
;                     demonstrating the use of Linux INT 80H syscalls
;                     to display text
;
; Build using these commands:
;   nasm -f elf32 -g -F stabs eatsyscall.asm
;   ld -m elf_i386 -o eaqtsyscall eatsyscall.o
;

SECTION .data           ; Section containing initialized data

    EatMsg: db "Eat at Joe's!",10
    EatLen: equ $-EatMsg

SECTION .bss            ; section containing uninitialized data

SECTION .text           ; section containing code

global _start           ; linker needs this to find the entry point

_start:
    nop                 ; This nop keeps gdb happy (see text)
    mov eax, 4          ; specify the sys_write syscall
    mov ebx, 1          ; specify file descriptor 1: Standard Output
    mov ecx, EatMsg     ; pass offset of the message
    mov edx, EatLen     ; pass the length of the message
    int 80H             ; make syscall to output the text to stdout

    mov eax, 1          ; specify exit syscall
    mov ebx, 0          ; return a code of zero
    int 80H             ; make syscall to terminate the program
