assume cs:code

code segment
s:
    mov ax, bx
    mov si, offset s
    mov di, offset s0
    mov ax, cs:[si]
    mov cs:[di], ax
s0:
    nop
    nop

code ends
end s