LongMode:
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
    ret