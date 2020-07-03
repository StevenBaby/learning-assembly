ASSUME DS:DATA CS:CODE

DATA SEGMENT

DATA ENDS


CODE SEGMENT

START:

mov ax,DATA
mov ds,ax

mov bx, 60h
mov word ptr [bx+0ch],38
add word ptr [bx+0eh],70
mov si,0
mov byte ptr [bx+10h+si],'V'
inc SI
mov byte ptr [bx+10h+si],'A'
inc SI
mov byte ptr [bx+10h+si],'X'

CODE ENDS

END START