assume cs:code

code segment

start:

    ; test cmp

    mov ax, 8
    mov bx, 3
    cmp ax, bx

    jmp short finish

finish:

    mov ax, 4c00h
    int 21h

code ends

end start