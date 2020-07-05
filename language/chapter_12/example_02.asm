
; 1. get interrupt code N
; 2. pushf
; 3. TF = 0, IF = 0
; 4. push CS
; 5. push IP
; 6. (IP)=(N *4), (CS)=(N*4+2)

assume cs:code 

code segment

start:

install:
    mov ax, cs
    mov ds, ax
    mov si, offset show_error

    mov ax, 0
    mov es, ax
    mov di, 200h

    mov cx, offset show_error_end - offset show_error

    cld; positive direction
    ; std; negative direction

    rep movsb

    mov ax, 0
    mov es, ax
    mov word ptr es:[0*4], 200h
    mov word ptr es:[0*4+2], 0

    mov ax, 1000h
    mov bh, 1
    div bh

    mov ax, 4c00h
    int 21h

show_error:
    jmp short show_error_start
show_error_data:
    db 'Overflow!', 0 
show_error_start:

    mov ax, cs
    mov ds, ax
    mov si, 200h + offset show_error_data - offset show_error

    mov ax, 0b800h
    mov es, ax
    mov di, 12*160 + 36 * 2

char:
    mov cl, ds:[si]
    cmp cl, 0
    je short show_error_ret

    mov al, ds:[si]
    mov es:[di], al
    inc si
    add di, 2
    jmp short char

show_error_ret:
    mov ax, 4c00h
    int 21h

show_error_end:


code ends

end start