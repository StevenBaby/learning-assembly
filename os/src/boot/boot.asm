boot_base equ 0x7c00;
seek_loader equ 1;

section boot align=16 vstart=boot_base

    ;clean screen
    mov ax, 3
    int 0x10;

    ;setup segment register
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov sp, boot_base

    ;print message
    mov si, message
    call print
    call load_loader

    xchg bx, bx
    jmp 0x1000:0


finish:
    sti ; open interrupt
    hlt ; halt cpu
    jmp finish

load_loader:
    ; read first sector
    mov ax, [cs:load_base]
    mov dx, [cs:load_base + 2]
    mov bx, 16
    div bx
    mov ds, ax
    mov es, ax

    xor di, di
    mov si, seek_loader
    xor bx, bx

    call read_harddisk_sector

    ret


read_harddisk_sector:   ;从硬盘读取一个逻辑扇区
                        ; EAX=逻辑扇区号
                        ; DS:EBX=目标缓冲区地址
                        ;返回：EBX=EBX+512
        pusha

        mov dx,0x1f2
        mov al,1
        out dx,al ;读取的扇区数

        inc dx                              ;0x1f3
        mov ax, si
        out dx, al                       ;LBA地址7~0

        inc dx                          ;0x1f4
        mov al, ah
        out dx, al                       ;LBA地址15~8

        inc dx                          ;0x1f5
        mov ax, di
        out dx, al                       ;LBA地址23~16

        inc dx                          ;0x1f6
        mov al, 0xe0
        or al, ah                      ;第一硬盘  LBA地址27~24
        out dx,al

        inc dx                          ;0x1f7
        mov al,0x20                     ;读命令
        out dx,al

    .waits:
        in al,dx
        and al,0x88
        cmp al,0x08
        jnz .waits                      ;不忙，且硬盘已准备好数据传输 

        mov cx,256                     ;总共要读取的字数
        mov dx,0x1f0
    .readw:
        in ax,dx
        mov [bx],ax
        add bx,2
        loop .readw

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

    load_base dd 0x10000;
    message db "Loader is loading...", 13, 10, 0
    times 510-($-$$) db 0
    db 0x55, 0xaa