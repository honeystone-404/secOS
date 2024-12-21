HEX_TABLE: db '0123456789ABCDEF', 0
%define KEYBOARD_INTERRUPTION       33
struc idt_entry
    .offset_low:        resw 1          ; Lower 16 bits of the ISR address
    .selector:          resw 1          ; GDT segment selector
    .ist:               resb 1          ; Interrupt Stack Table index
    .attributes:        resb 1          ; Type and attributes
    .offset_middle:     resw 1          ; Middle 16 bits of the ISR address
    .offset_high:       resd 1          ; Higher 32 bits of the ISR address
    .reserved:          resd 1          ; Reserved (must be 0)
endstruc

idt: times 256 resb 16                ; total 256 entries, 16byte each
idt_descriptor:
    dw $ - idt - 1
    dq idt

%macro enter_idt_entry 2
    lea rax, [%1]
    mov rdi, idt
    add rdi, 16 * %2
    mov word [rdi + idt_entry.offset_low], ax
    mov word [rdi + idt_entry.selector], gdt.code
    mov byte [rdi + idt_entry.ist], 0
    mov byte [rdi + idt_entry.attributes], 0x8e
    shr rax, 16
    mov word [rdi + idt_entry.offset_middle], ax
    shr rax, 32
    mov dword [rdi + idt_entry.offset_high], eax
    mov qword [rdi + idt_entry.reserved], 0
%endmacro

setup_ivt:
    enter_idt_entry zero_division_handler, 0
    enter_idt_entry keyboard_handler, 33
    ret

setup_idt:
    call setup_ivt
    lidt [idt_descriptor]
    ret

keyboard_handler:
    cli
    xor rax, rax
    in al, 0x60
    
    mov r8, 0x0f
    mov r9, 0xf0
    and r8, rax
    and r9, rax
    shr r9, 4
    
    mov rdi, 0xb8000
    
    mov dl, [HEX_TABLE + r9]
    mov dh, 0x70
    mov [rdi], dx
    
    add rdi, 2
    
    mov dl, [HEX_TABLE + r8]
    mov dh, 0x70
    mov [rdi], dx

.end:
    mov al, 0x20
    out 0x20, al
    out 0xa0, al
    sti
    iretq

zero_division_handler:
    cli
    mov al, 'A'
    mov ah, 0x70
    mov [0xb8000], ax
    mov al, 0x20
    out 0x20, al
    out 0xa0, al
    sti
    iretq
