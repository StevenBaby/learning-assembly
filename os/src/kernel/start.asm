%include "boot.inc"

bits 32
[section .text]

global _start
extern main

_start:
    xchg bx, bx
    call main
    xchg bx, bx
    jmp $