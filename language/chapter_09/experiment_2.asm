name "experiment_2"

assume cs:code ds:data

data segment
    db 'Welcome to asm!' ; 15
data ends

code segment

start:
    mov ax, 0b800H;
    mov es, ax
    mov ax, data
    mov ds, ax
    mov dx, 4 ; loop 3 lines
    mov bx, 1822; show in middle 1760(row) + 62 (column) 
line:
    mov cx, 15
    mov di, 0
char:
    mov al, ds:[di]
    mov es:[bx], al
    inc di
    inc bx

    ; 01000010B  = red - green
    ; 00000010B = black - green
    ; 11000010B = blink - red - green
    ; 01001010B = high - red - green
    ; 00000111B = black - white;
    ; 01110001B = white - blue;
    mov es:[bx], 11000010B ;
    inc bx
    loop char

    sub dx, 1
    mov cx, dx

    mov ax, bx
    add ax, 160
    sub ax, 30
    mov bx, ax
    loop line

code ends
end start