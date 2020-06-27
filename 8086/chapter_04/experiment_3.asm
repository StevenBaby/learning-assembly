assume cs:codesg

codesg segment ; 代码段开始

    mov ax,2000H ; 将 2000H 载入 AX 寄存器
    mov ss,ax ; 将 AX 中的值 (也就是 刚才的 2000H) 载入栈顶地址寄存器
    mov sp,0 ; 将 0 载入 栈偏移地址寄存器，也就是说栈里没数据
    add sp,10 ; 将栈顶偏移地址 加 10，栈顶地址变成了 200AH
    pop ax ; 将栈顶的 内容弹出载入 AX 寄存器，无论里面是什么，这时栈顶指针 SS + SP 变成了 000CH
    pop bx ; 将栈顶的 内容弹出载入 BX 寄存器，无论里面是什么，这时栈顶指针 SS + SP 变成了 000EH
    push ax ; 将 AX 中的内容入栈，这时栈顶指针 SS + SP 变成了 000CH
    push bx ; 将 BX 中的内容入栈，这时栈顶指针 SS + SP 变成了 000AH
    pop ax ; 将栈顶的 内容弹出载入 AX 寄存器，无论里面是什么，这时栈顶指针 SS + SP 变成了 000CH
    pop bx ; 将栈顶的 内容弹出载入 BX 寄存器，无论里面是什么，这时栈顶指针 SS + SP 变成了 000EH

    ; 程序返回
    mov ax,4c00H
    int 21H

codesg ends ; 代码段结束
end
