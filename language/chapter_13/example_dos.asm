assume cs:code 

data segment

    db 'Welcome to masm!', '$'

data ends

code segment

start:

    mov ah, 2 ; set cursor
    mov bh, 0 ; page 0
    mov dh, 5 ; line 5
    mov dl, 12; column 12
    int 10h

    mov ax, data
    mov ds, ax
    mov dx, 0

    mov ah, 9
    int 21h

    mov ax, 4c00h
    int 21h

code ends

end start