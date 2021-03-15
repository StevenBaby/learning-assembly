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

READ_DISK

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
