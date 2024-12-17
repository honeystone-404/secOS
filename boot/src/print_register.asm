print_string:
    ; Input: RSI = string address
    ;        RDI = VGA buffer
.loop:
    lodsb                      ; Load byte from [RSI] into AL
    test al, al                ; Check for null terminator
    je .done
    mov [rdi], al              ; Write ASCII char to VGA buffer
    add rdi, 2                 ; Advance VGA pointer
    jmp .loop
.done:
    ret

print_hex:
    ; Input: RAX = number, RDI = VGA buffer
    push rbx
    mov rcx, 16
.loop:
    shl rax, 4
    mov bl, al
    and bl, 0xF
    mov dl, [hex_table + rbx]
    mov [rdi], dl
    add rdi, 2
    loop .loop
    pop rbx
    ret

print_dec:
    ; Input: RAX = number, RDI = VGA buffer
    push rbx
    xor rbx, rbx
    mov rcx, 0
.convert:
    xor rdx, rdx
    mov r11, 10
    div r11
    add dl, '0'
    push rdx
    inc rcx
    test rax, rax
    jnz .convert

.print:
    pop rbx
    mov [rdi], bl
    add rdi, 2
    loop .print
    pop rbx
    ret

message_hex db "Hex: ", 0
message_dec db " Dec: ", 0
