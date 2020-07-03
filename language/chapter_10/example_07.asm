assume cs:code

data segment

    db 'conversation', 0
    db 'unix', 0
    db 'windpipe', 0
    db 'goodgoodstudy', 0

data ends


code segment

start:

    mov ax, data
    mov ds, ax
    mov bx, 0

    mov cx, 4
    mov si, 0
s:
    call capital
    loop s

    call finish

capital:
    push cx

change:
    mov cl, [si]
    mov ch, 0
    jcxz ok
    and byte ptr [si], 11011111b
    inc si
    jmp short change
ok: 
    inc si
    pop cx
    ret

finish:
    mov ax, 4c00h
    int 21h

code ends
end start