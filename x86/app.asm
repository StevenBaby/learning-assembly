
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

start:
    ; xchg bx, bx

    mov ax, [stack_segment]
    mov ss, ax
    mov sp, stack_end

    mov ax, [data_segment]
    mov ds, ax

    call clear_screen

    mov si, message
    call print

    jmp $

clear_screen:
    mov ax, 0x3
    int 0x10;
    ret

write_harddisk:
        pusha
        push ds

        mov bx, message
        mov byte [bx], 'K'

        mov si, 100
        xor di, di

        mov ax, 0x1000
        mov ds, ax

        mov dx, [2]
        mov ax, [0]
        mov bx, 512
        div bx
        cmp dx, 0
        je .direct
        inc ax

    .direct:

        ; xchg bx, bx;
        mov cx, ax; 记录写入扇区数量

        mov dx, 0x1f2
        ; mov al, al
        out dx, al ; 写入数量

        inc dx ; 0x1f3
        mov ax, si;
        out dx, al;  lba 地址 7-0

        inc dx; 0x1f4
        mov al, ah;
        out dx, al; lba address 15 - 8 

        inc dx; 0x1f5
        mov ax, di
        out dx, al ; lba address 23 - 16

        inc dx; 0x1f6
        mov al, 0xe0
        or al, ah; lba address 27-24
        out dx, al; 

        inc dx; 0x1f7
        mov al, 0x30; command write
        out dx, al

        ; xchg bx, bx;

    .waits:
        in al, dx
        and al, 0x88
        cmp al, 0x08
        jnz .waits

        ; xchg bx, bx;
        xor bx, bx

    .write_sector:
        push cx

        mov cx, 256
        mov dx, 0x1f0

        .readw:
            mov ax, [bx]
            out dx, ax
            ; in ax, dx
            ; mov [bx], ax
            add bx, 2
            nop
            nop
            nop
            nop
            nop
            loop .readw

        pop cx
        loop .write_sector

        pop ds
        popa
        ret

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
    push ds
    push es

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

    pop es
    pop ds
    popa

    ret

print:
    cld
    .print_loop:
        lodsb
        or al, al
        jz .print_done

        mov ah, 0x0e ; 0000 黑色背景 1110 浅灰色，默认颜色
        int 0x10;
        jmp .print_loop

    .print_done:
        ret

code_end:

section data align=16 vstart=0;
    message db 'Hello world!!!', 0
data_end:

section stack align=16 vstart=0;
    ; resb 256
    times 0x100 db 0; 干掉 warning
stack_end:

section trail align=16;
    ending db 'program ending', 0
program_end:
