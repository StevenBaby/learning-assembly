
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

    mov al, 0x70
    mov bl, 4
    mul bl
    mov bx, ax

    cli

    push es
    mov ax, 0x0000
    mov es, ax
    mov word [es:bx], int_0x70
    mov word [es:bx+2], cs
    pop es

    mov al,0x0b                        ;RTC寄存器B
    or al,0x80                         ;阻断NMI 
    out 0x70,al
    mov al,0x12                        ;设置寄存器B，禁止周期性中断，开放更 
    out 0x71,al                        ;新结束后中断，BCD码，24小时制 

    mov al,0x0c
    out 0x70,al
    in al,0x71                         ;读RTC寄存器C，复位未决的中断状态

    in al,0xa1                         ;读8259从片的IMR寄存器 
    and al,0xfe                        ;清除bit 0(此位连接RTC)
    out 0xa1,al                        ;写回此寄存器 

    sti                                ;重新开放中断 

    .idle:
        hlt                                ;使CPU进入低功耗状态，直到用中断唤醒
        jmp .idle

    jmp $

int_0x70:
        pusha
        push ds
        push es

        mov al,0x0a                         ;阻断NMI。当然，通常是不必要的
        or al,0x80                          
        out 0x70,al
        in al,0x71                          ;读寄存器A
        test al,0x80                        ;测试第7位UIP 
        jnz .return                         ;以上代码对于更新周期结束中断来说 
                                            ;是不必要的 

        xor al,al
        or al,0x80
        out 0x70,al
        in al,0x71                         ;读RTC当前时间(秒)
        call bcd_to_ascii
        mov [seconds], ax


        mov al, 2
        or al, 0x80
        out 0x70, al
        in al, 0x71                         ;读RTC当前时间(秒)
        call bcd_to_ascii
        mov [minutes], ax

        mov al, 4
        or al, 0x80
        out 0x70, al
        in al, 0x71                         ;读RTC当前时间(秒)
        call bcd_to_ascii
        mov [hours], ax

        mov al, 7
        or al, 0x80
        out 0x70, al
        in al, 0x71                         ;读RTC当前时间(日)
        call bcd_to_ascii
        mov [days], ax


        mov al, 8
        or al, 0x80
        out 0x70, al
        in al, 0x71                         ;读RTC当前时间(月)
        call bcd_to_ascii
        mov [months], ax

        mov al, 9
        or al, 0x80
        out 0x70, al
        in al, 0x71                         ;读RTC当前时间(年)
        call bcd_to_ascii
        mov [years], ax

        mov al,0x0c                         ;寄存器C的索引。且开放NMI 
        out 0x70,al
        in al,0x71                          ;读一下RTC的寄存器C，否则只发生一次中断
                                            ;此处不考虑闹钟和周期性中断的情况 
    ; 将 datetime 处的内容拷贝到 显存，以显示时间
        mov ax,0xb800
        mov es,ax

        mov si, datetime
        mov di, 12 * 160 + 30 * 2

    .showtime:
        mov ax, [si]
        cmp ax, 0
        je .return
        movsb
        inc di
        jmp .showtime

    .return:

        mov al,0x20                        ;中断结束命令EOI 
        out 0xa0,al                        ;向从片发送 
        out 0x20,al                        ;向主片发送 

        pop es
        pop ds
        popa

        iret


bcd_to_ascii:                            ;BCD码转ASCII
                                         ;输入：AL=bcd码
                                         ;输出：AX=ascii
                                         ; 采用小端方式，可以直接写入内存
                                         ; 设 AX = 0x0028

    mov ah, al                          ;分拆成两个数字  0x2828
    and al, 0xf0                        ;仅保留高4位 0x2820
    shr al, 4;                          ;0x2802
    add al, 0x30                        ;转换成ASCII 0x2832

    and ah, 0x0f                        ; 0x0832
    add ah, 0x30                        ; 0x3832; 结果

    ret

clear_screen:
    mov ax, 0x3
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
    datetime db '20'
    years db '21-'
    months db '02-'
    days db '02 '
    hours db '02:'
    minutes db '02:'
    seconds db '02', 0
data_end:

section stack align=16 vstart=0;
    ; resb 256
    times 0x100 db 0; 干掉 warning
stack_end:

section trail align=16;
    ending db 'program ending', 0
program_end:
