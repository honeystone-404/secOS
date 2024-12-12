setup_paging:
section .bss
    align 4096
    pml4: resb 4096
    pdp: resb 4096
    pdt: resb 4096
    pt: resb 4096

section .text
    mov eax, pdp
    or eax, 0x03
    mov [pml4], eax
    
    mov eax, pdt
    or eax, 0x03
    mov [pdp], eax
    
    xor eax, eax
    mov ecx, 512
    mov edi, pt
fill_pt:
    mov [edi], eax
    or dword [edi], 0x03
    add eax, 0x1000
    add edi, 8
    loop fill_pt

    mov eax, pt
    or eax, 0x03
    mov [pdt], eax

    ; load pml4 address into cr3
    mov eax, pml4
    mov cr3, eax

    ; enable physical address extension(PAE) bit in cr4
    mov eax, cr4
    or eax, 1<<5
    mov cr4, eax

    ; enable long mode enable(LME) bit in IA32_EFER msr
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1<<8
    wrmsr

    ; enable paging(PE) bit in cr0
    mov eax, cr0
    or eax, 1<<31
    mov cr0, eax

    ret