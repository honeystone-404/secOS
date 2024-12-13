%define ZERO_DIVISION_EXCEPTION     0
%define PAGE_FAULT                  14
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
idt: times 256 resb 16              ; total 256 entries, 16byte each
idt_descriptor:
    dw $ - idt - 1
    dq idt
%macro enter_idt_entry 2
    mov rax, [%1]
    mov rdi, idt
    add rdi, idt_entry * %2
    mov word [rdi + idt_entry.offset_low], ax
    mov word [rdi + idt_entry.selector], gdt.code
    mov byte [rdi + idt_entry.ist], 0
    mov byte [rdi + idt_entry.attributes], 0x8e
    shr rax, 16
    mov word [rdi + idt_entry.offset_middle], ax
    shr rax, 32
    mov dword [rdi + idt_entry.offset_high], eax
%endmacro

setup_idt:
    
    ; WHAT here?
    enter_idt_entry zero_division_handler, ZERO_DIVISION_EXCEPTION
    enter_idt_entry page_fault_handler, PAGE_FAULT
    enter_idt_entry keyboard_handler, KEYBOARD_INTERRUPTION

    lidt [idt_descriptor]
    ret

zero_division_handler:

    mov r8, VGA_ADDR
    mov rsi, z_msg
    mov rcx, z_msg_len
    call print

    mov al, 0x20
    out 0x20, al
    out 0xa0, al
    
    iretq

page_fault_handler:
    iretq

keyboard_handler:
    push rax

    xor rax, rax
    in al, 0x60
    mov ah, 0x70
    mov [VGA_ADDR], rax

    pop rax
    iretq
z_msg db "Division by zero", 0
z_msg_len equ $ - z_msg