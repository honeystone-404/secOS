%include "boot/src/print.asm"
LongMode:
    xor rax, rax
    cpuid
    mov [brand], rbx
    mov [brand + 4], rdx
    mov [brand + 8], rcx

    mov rax, 0x80000002
    cpuid
    mov [brand_string], rax
    mov [brand_string + 4], rbx
    mov [brand_string + 8], rcx
    mov [brand_string + 12], rdx

    mov rax, 0x80000003
    cpuid
    mov [brand_string + 16], rax
    mov [brand_string + 20], rbx
    mov [brand_string + 24], rcx
    mov [brand_string + 28], rdx
    
    mov rax, 0x80000004
    cpuid
    mov [brand_string + 32], rax
    mov [brand_string + 36], rbx
    mov [brand_string + 40], rcx
    mov [brand_string + 44], rdx

    xor rax, rax
    mov rax, 1
    cpuid

    mov r8, 0
.loop:
    cmp rdx, r8
    je ok
    add r8, 1
    cmp r8, 0x100000000
    je end
    jmp .loop
ok:
    mov r8, VGA_ADDR
    mov rsi, brand
    mov rcx, 13
    call print
end:
    ret

brand: times 13 db 0
brand_string: times 49 db 0
revID: times 2 db 0