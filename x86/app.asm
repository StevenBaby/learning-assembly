
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
    jmp $

code_end:

section data align=16 vstart=0;
    message db 'hello world!!!', 0
data_end:

section stack align=16 vstart=0;
    ; resb 256
    times 256 db 0; 干掉 warning
stack_end:

section trail align=16;
program_end:
