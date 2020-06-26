ASSUME CS:CODESG ; 表示 CODESG 是代码段

CODESG SEGMENT ; 代码段开始

    MOV AX,0123H ; 将 0123H 移动到 AX 寄存器中
    MOV BX,0456H ; 将 0456H 移动到 BX 寄存器中
    ADD AX,BX ; 将 BX 的值加到 AX 中
    ADD AX,AX ; 将 AX 的值加到 AX 中，相当于 AX * 2

    ; 程序返回
    MOV AX,4C00H
    INT 21H

CODESG ENDS

ENDS