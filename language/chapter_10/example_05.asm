assume cs:code

data segment

    dw 'conversation'

data ends


code segment

start:

    mov ax, data
    mov ds, ax
    mov si, 0
    mov cx, 12

    call capital

    call finish

capital:

    and byte ptr [si], 11011111b
    inc si
    loop capital
    ret

finish:
    mov ax, 4c00h
    int 21h

code ends
end start