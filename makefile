# Define variables
AS=nasm                  # Assembler command (nasm)
ASFLAGS=-f bin           # Assemble to flat binary format
OUTPUT=bin/boot.bin    	 # Final output bootloader binary
STAGE1=boot/stage1.asm
STAGE2=boot/stage2.asm
BIN1=bin/boot1.bin
BIN2=bin/boot2.bin
QEMU=qemu-system-x86_64   # QEMU emulator for running the bootloader
QEMUFLAGS=-drive format=raw,file=$(OUTPUT) -d int,cpu_reset -D qemu.log # QEMU flags to load the raw binary

# Default target
all: $(OUTPUT)
# Rule to assemble both stages
$(BIN1): $(STAGE1)
	$(AS) $(ASFLAGS) -o $(BIN1) $(STAGE1)
$(BIN2): $(STAGE1)
	$(AS) $(ASFLAGS) -o $(BIN2) $(STAGE2)

$(OUTPUT): $(BIN1) $(BIN2)
	cat $(BIN1) $(BIN2) > $(OUTPUT)

# Rule to run QEMU with the bootloader
run: $(OUTPUT)
	$(QEMU) $(QEMUFLAGS)

# Clean up generated files
clean:
	rm -f $(OUTPUT) $(BIN1) $(BIN2) 

# Phony targets (not actual files)
.PHONY: all run clean