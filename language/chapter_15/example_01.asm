assume cs:code

code segment

start:

    mov ax, 0b800h
    mov es, ax

mova:
    mov ah, 'a'
s:
    mov es:[160 * 12 + 40 * 2], ah
    inc ah
    cmp ah, 'z'
    je mova
    jmp short s

    mov ax, 4c00h
    int 21h

code ends

end start