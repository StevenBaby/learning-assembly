assume cs:code

data segment

data ends

code segment

start:

    mov ax, 0
    push ax
    popf
    mov ax, 0fff0h
    add ax, 0010h
    pushf
    pop ax
    and al, 11000101B
    and al, 00001000B

code ends

end start