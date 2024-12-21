gdt:
    .null: equ $ - gdt
    dq 0x00
    ; code segment descriptor
    .code: equ $ - gdt
    dw 0x0000           ; limit - ignored
    dw 0x0000           ; base - ignored
    db 0x00             ; base - ignored
    db 0x9a             ; access byte (P=1, DPL=00, S=1, E=1, DC=0, RW=1, A=0)
    db 0xa0             ; flags (G=1, DB=0, L=1, Reserved=0)
    db 0x00             ; base
    ; data segment descriptor
    .data: equ $ - gdt
    dw 0x0000           ; limit - ignored
    dw 0x0000           ; base - ignored
    db 0x00             ; base - ignored
    db 0x92             ; access byte (P=1, DPL=00, S=1, E=0, DC=0, RW=1, A=0)
    db 0xc0             ; flags (G=1, DB=1, L=0, Reserved=0)
    db 0x00             ; base
    .tss: equ $ - gdt
    
    .descriptor:
    dw $ - gdt - 1
    dq gdt
