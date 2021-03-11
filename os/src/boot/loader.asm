%include "boot.inc"

section loader vstart=LOADER_BASE_ADDR

    mov si, message_start_loader
    call print

    ; detect memory
    xor ebx, ebx
    mov edx, 0x534d4150
    mov di, ards_buffer

.check_memory_r820:
    mov eax, 0x0000e820
    mov ecx, 20
    int 0x15

    jc .get_memory_e801

    add di, cx
    inc word [ards_count]
    cmp ebx, 0
    jnz .check_memory_r820

    mov cx, [ards_count]
    mov ebx, ards_buffer
    xor edx, edx

.get_max_memory_area:

    mov eax, [ebx]
    add eax, [ebx + 8]
    add ebx, 20
    cmp edx, eax
    jge .next_ards
    mov edx, eax

.next_ards:
    loop .get_max_memory_area
    jmp .get_memory_ok

.get_memory_e801:
    mov ax, 0xe801
    mul cx
    shl edx, 16
    and eax, 0x0000ffff
    or edx, eax
    add edx, 0x100000
    mov esi, edx

    xor eax, eax
    mov ax, bx
    mov ecx, 0x10000
    mul ecx
    add esi, eax
    mov edx, esi
    jmp .get_memory_ok

.get_memory_e88:
    mov ah, 0x88
    int 0x15
    jc .get_memory_failure

    and eax, 0x0000ffff

    mov cx, 0x400
    mul cx

    shl edx, 16
    or edx, eax
    and edx, 0x100000

.get_memory_ok:
    mov [total_memory_bytes], edx
    xchg bx, bx

.get_memory_failure:
finish:
    sti ; open interrupt
    hlt ; halt cpu
    jmp finish



print:
    cld
    .print_loop:
        lodsb
        or al, al
        jz .print_done

        mov ah, 0x0e;
        int 0x10;
        jmp .print_loop
    .print_done:
        ret

message_start_loader db "Loader is starting...", 13, 10, 0

total_memory_bytes dd 0
ards_count  dw 0
ards_buffer times 600 db 0
