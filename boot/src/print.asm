print:
    .loop:
        lodsb
        or al, al
        jz .end
        mov ah, 0x70
        mov [r8], rax
        add r8, 2
        loop .loop
    .end:
        ret