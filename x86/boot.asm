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

_start:
    ; xchg bx, bx;

    mov ax, cs;
    mov ds, ax;
    mov ss, ax;
    mov sp, base;

    mov ax, 0x0003; clear screen
    int 0x10;

    mov ax,video  ;指向文本模式的显示缓冲区
    mov es,ax

    ;以下显示字符串 message
    mov si, message
    call print

    xor ax, ax
    mov cx, 100

calculate:
    add ax, cx
    loop calculate

    ; xchg bx, bx;

    xor cx, cx
split:
    mov bx, 10;
    mov dx, 0;
    div bx ; (dx ax) / bx = 商(ax) 余数(dx)

    add dl, 0x30;
    push dx

    ; xchg bx, bx;

    inc cx
    cmp ax, 0
    jne split

show_result:
    pop ax
    mov ah, 0x0e ; 0000 黑色背景 1110 浅灰色，默认颜色
    int 0x10;
    loop show_result

infi: jmp near infi                 ;无限循环

message db "1+2+3+...+99+100=", 0; 字符串以 0 结尾
times   510 - ($ - $$) db 0
        dw 0xaa55; db 0x55,0xaa