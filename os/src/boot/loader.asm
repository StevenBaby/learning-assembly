%include "boot.inc"

section loader vstart=LOADER_BASE_ADDR

    mov si, message_start_loader
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

        mov ah, 0x0e;
        int 0x10;
        jmp .print_loop
    .print_done:
        ret

message_start_loader db "Loader is starting...", 13, 10, 0
