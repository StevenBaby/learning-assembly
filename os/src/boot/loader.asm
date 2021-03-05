base_address equ 0x10000

section loader vstart=base_address

mov si, message_loaded
call print

finish:
    sti ; open interrupt
    hlt ; halt cpu
    jmp finish

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

message_loaded db "Loader is started", 13, 10, 0
