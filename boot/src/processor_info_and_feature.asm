[bits 64]
hex_table db "0123456789ABCDEF", 0
; processor info and features
pif:
    xor rax, rax
    mov rax, 1
    cpuid
detect_processor_type:
    mov r8, 0xf000
    and  r8, rax
    shr r8, 12
    lea rsi, [hex_table + r8]
    mov qword [processorType], rsi
detect_stepping_id:
    mov r8, 0xf
    and r8, rax
    lea rsi, [hex_table + r8]
    mov [steppingId], rsi
    mov rsi, processorType
    mov rdi, VGA_ADDR
    mov rcx, 1
    call print
    add rdi, 2
    mov rsi, steppingId
    mov rcx, 1
    call print
    jmp halt
detect_model_id:
detect_family_id:

    mov r8, 0x0f0
    mov r9, 0xff0000
    and r8, rax
    and r9, rax
    shr r8, 4
    shr r9, 12
    add r8, r9
    mov r9, 0x0f
    and r9, r8
    lea rsi, [hex_table + r9]
    mov rdi, VGA_ADDR
    mov rcx, 1
    call print
    mov r9, 0x0f0
    and r9, r8
    shr r9, 4
    lea rsi, [hex_table + r9]
    mov rcx, 1
    call print
    mov r9, 0xf00
    and r9, r8
    shr r9, 8
    lea rsi, [hex_table + r9]
    mov rcx, 1
    call print
    ret
modelId: times 2 db 0
processorType: db 0
steppingId: db 0