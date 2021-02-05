    boot_base equ 0x7c00;
    video_base equ 0xb800;

section mbr align=16 vstart=0x7c00
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
    mov ax, 0x0003; clear screen
    int 0x10;

    mov ax, cs;
    mov ds, ax;
    mov ss, ax;
    mov sp, boot_base;

    mov ax,video_base  ;指向文本模式的显示缓冲区
    mov es,ax

    jmp $
    ; mov ax, [cs:user_base]
    ; mov dx, [cs:user_base + 0x02]
    ; mov bx, 16
    ; div bx
    ; mov ds, ax
    ; mov es, ax

calculate_segment_base:
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

user_base dd 0x10000;
message db 'hello boot!!!', 0
times   510 - ($ - $$) db 0
        dw 0xaa55; db 0x55,0xaa