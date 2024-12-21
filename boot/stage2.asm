[org 0x8000]
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
%include "boot/lm.asm"
%include "boot/src/print.asm"
%include "boot/src/idt.asm"
LongModeEntry:
    call set_seg_regs
    mov rsp, 0x80000
    mov rbp, rsp
    call setup_idt
    call LongMode
halt:
    hlt
    jmp halt
VGA_ADDR: dq 0xb8000
