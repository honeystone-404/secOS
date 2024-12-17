print:
    .loop:
        lodsb
        or al, al
        jz .end
        mov ah, 0xc0
        mov [rdi], rax
        add rdi, 2
        loop .loop
    .end:
        ret
