[org 0x7c00]

    base equ 0x7c00;
    video equ 0xb800;
    jmp _start

print:
    cld
print_loop:
    lodsb
    or al, al
    jz print_done
    mov ah, 0x0e ; 0000 黑色背景 1110 浅灰色，默认颜色
    int 0x10;
    jmp print_loop
print_done:
    ret

test:

    xchg bx, bx
    ret

_start:
    mov ax, cs;
    mov ds, ax;
    mov ss, ax;
    mov sp, base;

    mov ax, 0x0003; clear screen
    int 0x10;

    mov ax,video  ;指向文本模式的显示缓冲区
    mov es,ax

    ;以下显示字符串"Label offset:"
    mov si, message
    call print

    mov ax,number  ;取得标号number的偏移地址
    mov cx, 5;
number_loop:

    mov bx,10
    mov dx,0
    div bx ; (dx ax) / bx = 商(ax) 余数(dx)

    mov bx, dx;
    mov dl, [bx + string]

    mov bx, cx;
    mov [bx + number - 1], dl

    loop number_loop

    mov si, number
    call print

    call test

infi: jmp near infi                 ;无限循环

string: db '0123456789ABCDEF', 0

number db 0,0,0,0,0, 'D', 0
message db "Label offset:", 0; 字符串以 0 结尾
times   510 - ($ - $$) db 0
        dw 0xaa55; db 0x55,0xaa