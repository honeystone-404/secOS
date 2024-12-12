set_seg_regs:
    mov ax, gdt.data
    mov ds, ax
    mov es, ax
    mov gs, ax
    mov fs, ax
    mov ss, ax
    ret