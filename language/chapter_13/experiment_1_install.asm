assume cs:code

code segment

start:

    mov ax, cs
    mov ds, ax
    mov si, offset process

    mov ax, 0
    mov es, ax
    mov di, 200h
    mov cx, offset process_end - offset process

    cld
    rep movsb

    mov ax, 0 
    mov es, ax
    mov word ptr es:[7ch * 4], 200h
    mov word ptr es:[7ch * 4 + 2], 0
    mov ax, 4c00h
    int 21h

process:
    mov al, dh
    mov bl, 160 ; line number
    mul bl; row

    mov dh, 0
    add ax, dx; column
    add ax, dx; * 2
    mov bx, ax ; mov start location

    mov ax, 0b800H;
    mov es, ax

    mov dl, cl
    mov di, 0

char:
    mov cl, ds:[di]
    mov ch, 0
    jcxz ok

    mov al, ds:[di]
    mov es:[bx], al
    inc di
    inc bx
    mov es:[bx], dl ;
    inc bx
    jmp short char

ok:
    iret

process_end: nop

code ends

end start