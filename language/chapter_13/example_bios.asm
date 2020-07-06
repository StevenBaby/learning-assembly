assume cs:code 

code segment

start:

    mov ah, 2 ; set cursor
    mov bh, 0 ; page 0
    mov dh, 5 ; line 5
    mov dl, 12; column 12
    int 10h

    mov ah, 9
    mov al, 'a'
    mov bl, 11001010b; color
    mov bh, 0
    mov cx, 3
    int 10h

    mov ax, 4c00h
    int 21h

code ends

end start