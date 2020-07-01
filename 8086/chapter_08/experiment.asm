ASSUME ds:data cs:code 

data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'

    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

    dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
    dw 11542, 14430, 15257, 17800

data ends

table segment
db 21 dup ('year summ ne ?? ')
table ends

code segment
start:
    mov ax, data
    mov es, ax

    mov ax, table
    mov ds, ax

    mov bx, 0 ; table row
    mov bp, 0 ; year
    mov si, 0 ; employee
    mov cx, 21 ; loop count
s:
    ; mov year
    mov ax,es:[bp+0]
    mov ds:[bx+0],ax
    mov ax,es:[bp+2]
    mov ds:[bx+2],ax

    ; mov sum
    mov ax,es:[bp+54H]
    mov ds:[bx+5],ax
    mov ax,es:[bp+56H]
    mov ds:[bx+7],ax

    mov ax,es:[si+0A8H]
    mov ds:[bx+10],ax

    mov ax,ds:[bx+5]
    mov dx,ds:[bx+7]
    div word ptr ds:[bx+10]
    mov ds:[bx+13],ax

    add si,2
    add bp,4
    add bx,10h
    loop s

    mov ax, 4c00h
    int 21h

code ends

end start