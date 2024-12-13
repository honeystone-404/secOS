[org 0x8000]
%define VGA_ADDR 0xb8000
start:
    cli
    mov eax, cr0
    or eax, 0x01
    mov cr0, eax
    lgdt [gdt32.descriptor]
    jmp gdt32.code:ProtectedModeEntry
[bits 32]
%include "boot/src/gdt32.asm"
%include "boot/src/seg_reg32.asm"
%include "boot/src/gdt.asm"
%include "boot/src/paging.asm"
ProtectedModeEntry:
    call set_seg_regs32
    cli
    call setup_paging
    lgdt [gdt.descriptor]
    jmp gdt.code:LongModeEntry
[bits 64]
%include "boot/src/set_seg.asm"
LongModeEntry:
    call set_seg_regs
    mov rsp, 0x80000
    mov rbp, rsp

    xor rax, rax
    cpuid
    mov [id_string], rbx
    mov [id_string + 4], rdx
    mov [id_string + 8], rcx

    mov rsi, id_string
    mov rcx, 13
    mov rbx, VGA_ADDR
    .print_loop:
        lodsb
        or al, al
        jz halt
        mov ah, 0x8b
        mov [rbx], rax
        add rbx, 2
        loop .print_loop
    ; TODO: Implement IDT
halt:
    hlt
    jmp halt

id_string: times 13 db 0