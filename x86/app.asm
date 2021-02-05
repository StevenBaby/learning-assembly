
section header vstart=0;
    length          dd program_end
    entry           dw start; 偏移地址
                    dd section.code.start; 段地址
    table           dw (header_end - code_segment)/4 ; 段重定位表项个数
    code_segment    dd section.code.start;
    data_segment    dd section.data.start;
    stack_segment   dd section.stack.start;
header_end:

section code align=16 vstart=0


clear_screen:
    mov ax, 0x3
    int 0x10;
    ret

start:
    mov ax, [stack_segment]
    mov ss, ax
    mov sp, stack_end

    mov ax, [data_segment]
    mov ds, ax

    call clear_screen

    mov cx, 23
show_string:
    mov si, message
    call print
    loop show_string
    ; mov cx, data_end - message - 1

    ; xchg bx, bx;

    mov al, 22
    call scroll_screen

    jmp $

get_cursor:
    ; 将光标位置 写入 AX 寄存器
    push dx

    mov dx, 0x3d4; 索引寄存器端口号
    mov al, 0x0e ; 光标寄存器 高八位
    out dx, al

    mov dx, 0x3d5; 数据端口号
    in al, dx; 获得高八位
    mov ah, al;

    mov dx, 0x3d4; 索引寄存器端口号
    mov al, 0x0f ; 光标寄存器 低八位
    out dx, al

    mov dx, 0x3d5; 数据端口号
    in al, dx; 获得低八位

    pop dx
    ret; 结果存在 ax 寄存器中

set_cursor:
    ; 将 AX 寄存器中的光标位置 写入显卡

    push dx
    push bx
    push ax

    mov bx, ax;

    mov dx, 0x3d4; 索引寄存器端口号
    mov al, 0x0e ; 光标寄存器 高八位
    out dx, al

    mov dx, 0x3d5; 数据端口号
    mov al, bh; 获得高八位
    out dx, al; 写入高八位

    mov dx, 0x3d4; 索引寄存器端口号
    mov al, 0x0f ; 光标寄存器 低八位
    out dx, al

    mov dx, 0x3d5; 数据端口号
    mov al, bl; 获得低八位
    out dx, al; 写入低八位

    pop ax
    pop bx
    pop dx
    ret;

scroll_screen:
    ; 向上滚动 Al 行;
    pusha

    mov bx, 0xb800;
    mov ds, bx;
    mov es, bx;

    cld; 递增方向

    push ax;

    mov ah, 80 * 2;
    mul ah
    mov si, ax;
    mov di, 0x00

    mov cx, 80 * 24;
    rep movsw

    pop ax;
    mov ah, 80;
    mul ah; 计算字符数量

    ;清除新出现的行
    mov bx, 25 * 80 * 2;
    mov cx, ax;
    shl ax, 1;
    sub bx, ax;
    mov si, ax;

    .cls:
    sub si, 2
    mov word [es:bx + si], 0x0720; 0x07 默认颜色; 0x20 空格
    loop .cls

    popa
    ret

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

code_end:

section data align=16 vstart=0;
    message db '  This is test message, length is 80 ......................................  !!!', 0
data_end:

section stack align=16 vstart=0;
    ; resb 256
    times 256 db 0; 干掉 warning
stack_end:

section trail align=16;
program_end:
