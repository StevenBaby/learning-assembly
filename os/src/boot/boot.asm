%include "boot.inc"

section boot align=16 vstart=BOOT_BASE_ADDR

    ;clean screen
    mov ax, 3
    int 0x10;

    ;setup segment register
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov sp, BOOT_BASE_ADDR

    ;print message
    mov si, message
    call print

    call load_loader

    jmp 0:LOADER_BASE_ADDR

finish:
    sti ; open interrupt
    hlt ; halt cpu
    jmp finish

load_loader:
    ; read first sector
    mov eax, LOADER_START_SECTOR
    mov bx, LOADER_BASE_ADDR
    mov cx, 20 ; 10KB
    call read_disk

    ret

read_disk: 
    ;从硬盘读取一个逻辑扇区
    ; EAX = 逻辑扇区号
    ; DS: EBX = 目标缓冲区地址
    ; CX, 读取的扇区数量

        pusha

        push eax

        ; 设置需要读取的扇区数
        mov dx, 0x1f2
        mov al, cl
        out dx, al

        pop eax

        ; 写入 LBA地址 7 ~ 0
        inc dx  ;0x1f3
        out dx, al;

        ; 写入 LBA地址 15 ~ 8
        inc dx ;0x1f4
        shr eax, 8
        out dx, al

        ; 写入 LBA地址 23 ~ 16
        inc dx ;0x1f5
        shr eax, 8
        out dx, al

        ; 写入 第一硬盘  LBA地址27~24
        inc dx ;0x1f6
        shr eax, 8
        and al, 0x0f
        or al, 0xe0
        out dx,al

        ; 写入读命令
        inc dx ;0x1f7
        mov al, 0x20
        out dx,al

    .waits:
        in al,dx
        and al,0x88
        cmp al,0x08
        jnz .waits ; 不忙，且硬盘已准备好数据传输 

        mov ax, cx
        mov dx, 256 ;总共要读取的字数
        mul dx
        mov cx, ax
        mov dx, 0x1f0 ; 读取端口号

    .readw:
        in ax,dx ; 读取输入
        mov [bx], ax ; 转移到内存
        add bx , 2; 一次读取两个字节

        loop .readw

        popa

        ret

print:
    cld
    .print_loop:
        lodsb
        or al, al
        jz .print_done

        mov ah, 0x0e; 
        int 0x10;
        jmp .print_loop
    .print_done:
        ret

    message db "Boot is loading...", 13, 10, 0
    times 510-($-$$) db 0
    db 0x55, 0xaa
