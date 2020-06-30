assume cs:code ds:data

data segment
    db 'unIX'
    db 'foRK'
data ends

code segment

start:
    MOV al, 'a'
    MOV bl, 'b'

    mov ax, 4c00h
    int 21h
code ends

end start