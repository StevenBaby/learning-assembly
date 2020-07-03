ASSUME CS:CODE

CODE SEGMENT

    dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h

    dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
START:
    MOV AX, CS
    MOV SS, AX
    MOV SP, 30H

    MOV BX, 0
    MOV CX, 8

S:  PUSH CS:[BX]
    ADD BX, 2
    LOOP S

    MOV BX, 0
    MOV CX, 8

S0: POP CS:[BX]
    ADD BX, 2
    LOOP S0

    MOV AX, 4C00H
    INT 21H


CODE ENDS
END START
