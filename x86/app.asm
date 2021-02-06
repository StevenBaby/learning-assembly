
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

    .idle:
        call get_key
        ; hlt                                ;使CPU进入低功耗状态，直到用中断唤醒
        jmp .idle

    jmp $

clear_screen:
    mov ax, 0x3
    int 0x10;
    ret

get_key:
    mov ah, 0x00
    int 0x16

    mov ah, 0x0e
    int 0x10;

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
