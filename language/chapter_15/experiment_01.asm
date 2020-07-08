
assume cs : code, ss : stack

stack SEGMENT
    dw 64 dup (0)
stack ENDS

code SEGMENT

start:    ;改变中断向量到本程序中的中断例程处
    mov ax, 0
    mov es, ax
    mov ax, stack
    mov ss, ax
    mov sp, 64
    mov ds, ax
    
    ;分别将中断程序cs:ip入栈ds:[si]分别存ip，cs
    push es : [9 * 4 + 2]
    push es : [9 * 4]
    mov si, sp
    
    ;改变中断向量
    cli
    mov ax, code
    mov es : [9 * 4 + 2], ax
    mov word ptr es : [9 * 4], offset int9
    sti
    
    mov ax, 0b800h
    mov es, ax
    mov bl, 'A'
print:    mov es : [12 * 160 + 36 * 2], bl
    add bl, 1
    call delay
    cmp bl, 'Z'
    jna print
    
    ;改回中断向量
    mov ax, 0
    mov es, ax
    cli
    mov ax, word ptr ds : [si + 2]
    mov es : [9 * 4 + 2], ax
    mov ax, word ptr ds : [si]
    mov es : [9 * 4], ax
    sti

    mov ax, 4c00h
    int 21h


delay:    push ax
    push bx
    mov ax, 0
    mov bx, 1000h
wl:    
    sub ax, 1
    sbb bx, 0
    cmp ax, 0
    jne wl
    cmp bx, 0
    jne wl
    pop bx
    pop ax
    ret

;原来的中断例程存放在ds:[si]处
int9:       
    push ax
    push es
    pushf ;中断例程最后是iret
    
    ;注意是dword
    call dword ptr ds : [si] ;运行原中断例程处理硬件细节

    in al, 60h
    cmp al, 1
    jne int9end

    mov ax, 0b800h
    mov es, ax
    add byte ptr es : [12 * 160 + 36 * 2 + 1], 1

int9end:    
    pop es
    pop ax
    iret

code ends
end start
    
