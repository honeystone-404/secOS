gdt32:
    .null: equ $ - gdt32
    dq 0x00
    .code: equ $ - gdt32
    dw 0xffff
    dw 0x0000
    db 0x00
    db 0x9a
    db 0xcf
    db 0x00
    .data: equ $ - gdt32
    dw 0xffff
    dw 0x0000
    db 0x00
    db 0x92
    db 0xcf
    db 0x00
    .descriptor:
    dw $ - gdt32 - 1
    dd gdt32