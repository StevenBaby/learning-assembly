assume cs:code

data segment

    dw 'conversation', 0

data ends


code segment

start:

    mov ax, data
    mov ds, ax
    mov si, 0

    call capital

    call finish

capital:
    mov cl, [si]
    mov ch, 0
    jcxz ok
    and byte ptr [si], 11011111b
    inc si
    jmp short capital
ok:
    ret

finish:
    mov ax, 4c00h
    int 21h

code ends
end start