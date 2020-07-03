assume cs:code

data segment

    db 'Welcome to asm!', 0

data ends


code segment

start:
    mov dh, 8
    mov dl, 3
    mov cl, 2

    mov ax, data
    mov ds, ax
    mov si, 0

    call show_str

    call finish

show_str:

    mov al, dh
    mov bl, 160 ; line number
    mul bl; row

    mov dh, 0
    add ax, dx; column
    add ax, dx; * 2
    mov bx, ax ; mov start location

    mov ax, 0b800H;
    mov es, ax
   
    mov ax, data
    mov ds, ax

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
    ret

finish:
    mov ax, 4c00h
    int 21h

code ends
end start