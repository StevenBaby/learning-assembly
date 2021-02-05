    boot_base       equ 0x7c00;
    video_base      equ 0xb800;
    app_lba_start   equ 100;

section mbr align=16 vstart=0x7c00
    start:
        ; xchg bx, bx;
        mov ax, 0x0003; clear screen
        int 0x10;

        mov ax, cs;
        mov ds, ax;
        mov ss, ax;
        mov sp, boot_base;

        mov ax,video_base  ;指向文本模式的显示缓冲区
        mov es,ax

        ; 令 ds, es 指向 user_base 代表的位置
        mov ax, [cs:user_base]
        mov dx, [cs:user_base + 0x02]
        mov bx, 16
        div bx
        mov ds, ax
        mov es, ax

        ; read first sector
        xor di, di
        mov si, app_lba_start
        xor bx, bx

        call read_harddisk

        mov dx, [2]
        mov ax, [0]
        mov bx, 512
        div bx
        cmp dx, 0

        ; xchg bx, bx;

        jnz @1
        dec ax
    @1:
        cmp ax, 0
        jz direct

        push ds
        mov cx, ax
    @2:
        mov ax, ds
        add ax, 0x20
        mov ds, ax

        xor bx, bx
        inc si
        call read_harddisk
        loop @2
        pop ds
    direct:

        mov dx, [0x08]
        mov ax, [0x06]
        call calc_segment_base

        ; xchg bx, bx;

        mov [0x06], ax

        mov cx, [0x0a]
        mov bx, 0x0c

    realloc:
        mov dx, [bx + 0x02]
        mov ax, [bx]
        call calc_segment_base

        ; xchg bx, bx;

        mov [bx], ax
        add bx, 4
        loop realloc

    jmp far [0x04]

read_harddisk:
    pusha

    mov dx, 0x1f2
    mov al, 1
    out dx, al ; 读取数量

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
    mov al, 0x20; command read
    out dx, al

    ; xchg bx, bx;

.waits:
    in al, dx
    and al, 0x88
    cmp al, 0x08
    jnz .waits

    ; xchg bx, bx;
    mov cx, 256
    mov dx, 0x1f0
.readw:
    in ax, dx
    mov [bx], ax
    add bx, 2
    loop .readw

    popa
    ret

calc_segment_base:
    ; calculate 
    ;计算16位段地址
    ;输入：DX:AX=32位物理地址
    ;返回：AX=16位段基地址

    push dx

    add ax, [cs:user_base]
    add dx, [cs:user_base + 2]
    shr ax, 4;
    ror dx, 4;
    and dx, 0xf000;
    or ax, dx;

    pop dx
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

user_base dd 0x10000;
message db 'hello boot!!!', 0
times   510 - ($ - $$) db 0
        dw 0xaa55; db 0x55,0xaa