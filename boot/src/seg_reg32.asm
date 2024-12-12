set_seg_regs32:
    mov ax, gdt32.data
    mov ds, ax
    mov es, ax
    mov gs, ax
    mov fs, ax
    mov ss, ax
    ret