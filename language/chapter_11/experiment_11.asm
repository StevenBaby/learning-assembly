name 'letterc'

assume cs:code

data segment

    db "Beginner's All-purpose Symbolic Instruction Code.",0

data ends

code segment

start:

    mov ax, data
    mov ds, ax

    mov si, 0

    call letterc

    call finish

letterc:

    mov al, [si]
    cmp al, 0
    je finish
    cmp al, 'a'
    jb next
    cmp al, 'z'
    ja next

    ;and al, 11011111B
    ;mov [si], al

    and [si], 11011111B
    
next:
    inc si
    jmp short letterc


finish:

    mov ax, 4c00h
    int 21h

code ends

end start