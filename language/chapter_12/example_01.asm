
; 1. get interrupt code N
; 2. pushf
; 3. TF = 0, IF = 0
; 4. push CS
; 5. push IP
; 6. (IP)=(N *4), (CS)=(N*4+2)

assume cs:code

code segment

start:
    mov ax, 1000h
    mov bh, 1
    div bh

    call finish

finish:

    mov ax, 4c00h
    int 21h

code ends

end start