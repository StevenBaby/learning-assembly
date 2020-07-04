assume cs:code

code segment

start:

    ; test ZF
    mov ax, 1
    sub ax, 1

    mov ax, 2
    sub ax, 1

    ; test PF
    mov al, 1
    add al, 10

    mov al, 1
    or al, 2

    ; test SF

    mov al, 10000001B
    add al, 1

    mov al, 10000001B
    add al, 01111111B

    ; test CF

    mov al, 98h
    add al, al

    jmp short finish

finish:

    mov ax, 4c00h
    int 21h

code ends

end start