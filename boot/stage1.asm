[bits 16]
[org 0x7c00]          ; BIOS Bootloader Origin
    ; Load Stage 2 into memory
    mov ah, 0x02         ; BIOS read sectors
    mov al, 10           ; Number of sectors to read (adjust for Stage 2 size)
    mov ch, 0            ; Cylinder
    mov cl, 2            ; Starting sector
    mov dh, 0            ; Head
    mov dl, 0x80         ; Drive (first HDD)
    mov bx, 0x8000       ; Load Stage 2 at 0x8000
    int 0x13             ; Call BIOS to read sectors

    ; Jump to Stage 2
    jmp 0x0000:0x8000    ; Assuming Stage 2 starts at 0x8000
    jmp halt
halt:
    hlt
    jmp halt

times 510-($-$$) db 0   ; Pad to 512 bytes
dw 0xaa55               ; Boot signature
