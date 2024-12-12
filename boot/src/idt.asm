struc idt_entry_t
    .isr_low:       resw 1          ; uint16_t - Lower 16 bits of the ISR address
    .kernel_cs:     resw 1          ; uint16_t - GDT segment selector
    .ist:           resb 1          ; uint8_t  - Interrupt Stack Table index
    .attributes:    resb 1          ; uint8_t  - Type and attributes
    .isr_mid:       resw 1          ; uint16_t - Middle 16 bits of the ISR address
    .isr_high:      resd 1          ; uint32_t - Higher 32 bits of the ISR address
    .reserved:      resd 1          ; uint32_t - Reserved (must be 0)
endstruc

section .bss
align 16
idt_table: times 256 resb 16 ; Allocate space for 256 IDT entries

section .data
align 16
idt_p:
    dw 256 * 16 - 1 ; Limit: size of the IDT - 1
    dq idt_table               ; Base address of the IDT table

section .text
global init_idt_entry

init_idt_entry:
    ; Calculate the offset for the keyboard interrupt (IRQ1)
    idt_entry_offset equ 33 * 16

    ; Example ISR address: keyboard_handler
    lea rax, [keyboard_handler] ; Load address of ISR into RAX

    ; Fill the idt_entry fields
    mov word [idt_table + idt_entry_offset + idt_entry_t.isr_low], ax          ; Lower 16 bits of ISR address
    shr rax, 16
    mov word [idt_table + idt_entry_offset + idt_entry_t.isr_mid], ax          ; Middle 16 bits of ISR address
    shr rax, 16
    mov dword [idt_table + idt_entry_offset + idt_entry_t.isr_high], eax       ; Upper 32 bits of ISR address

    ; Set the kernel code segment (e.g., 0x08 for kernel code segment in GDT)
    mov word [idt_table + idt_entry_offset + idt_entry_t.kernel_cs], 0x08

    ; Set IST (0 for now)
    mov byte [idt_table + idt_entry_offset + idt_entry_t.ist], 0

    ; Set attributes (e.g., 0x8E = Present, DPL=0, Interrupt Gate)
    mov byte [idt_table + idt_entry_offset + idt_entry_t.attributes], 0x8E

    ; Set reserved field to 0
    mov dword [idt_table + idt_entry_offset + idt_entry_t.reserved], 0

    ; Load the IDT using lidt
    lidt [idt_p]

    ret

; Example keyboard handler
keyboard_handler:
     mov rsi, 0x0D6c0D6c0D650D48
    mov [VGA_ADDR+24], rsi
    ; Send End of Interrupt (EOI) to the PICs
    mov al, 0x20
    out 0x20, al                ; Notify master PIC
    out 0xA0, al                ; Notify slave PIC

    ; Your keyboard handling logic here (e.g., read scancode, etc.)

    iretq