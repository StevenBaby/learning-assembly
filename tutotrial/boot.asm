mov ax, 3; 设置功能
int 0x10; 调用中断清除屏幕

mov ah, 0x0e; 字符颜色
mov al, 'B'; 字符数据
int 0x10; 调用中断显示字符

jmp $ ; 跳转到当前行，阻塞继续执行

times 510-($-$$) db 0
db 0x55, 0xaa
