; adapted from asmtutor.com
; run make to compile and link

SECTION .data
    msg db  'Hello, brave new world!', 0Ah     ; assign message variable with our message string

SECTION .text
    global _start

_start:

    mov ebx, msg        ; move the address of our message string into EBX
    mov eax, ebx        ; move the address in EBX into EAX as well (both now point ot the same spot)

nextchar:
    cmp byte [eax], 0   ; compare the byte pointed to by EAX at this address against zero
                        ; (zero is the end-of-string delimiter or \nul)
    jz finished         ; jump (if the zero flag has been set) to the 'finished' label
    inc eax             ; otherwise, increment the address in EAX by one byte
    jmp nextchar        ; jump back to the top of the loop

finished:
    sub eax, ebx        ; subtract the address in EBX from teh address in EAX
                        ; remember both registeres started pointing ot the same address (line 12)
                        ; but EAX has been icnremented one byte for each char in the msg string
                        ; when you subtract one memory address from another of the same type the
                        ; result is the number of segments between them... in this case, the # of bytes

    mov edx, eax        ; eax now equals the number of bytes in our string
    mov ecx, msg
    mov ebx, 1
    mov eax, 4
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h
