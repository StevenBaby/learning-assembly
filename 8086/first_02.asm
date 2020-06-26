; calculate 2^3

ASSUME CS:ABC

ABC SEGMENT

    ; move 2 to register ax
    MOV AX,2
    ; add ax ax = 4
    ADD AX,AX
    ; add ax again ax = 8
    ADD AX,AX

    ; program return
    MOV AX,4C00H
    INT 21H ; finish

ABC ENDS
END