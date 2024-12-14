md bin
nasm -f bin -o bin/stage1.bin boot/stage1.asm
nasm -f bin -o bin/stage2.bin boot/stage2.asm
copy /v /y /b bin\stage1.bin + /b bin\stage2.bin bin\boot.bin /b
qemu-system-x86_64 -drive format=raw,file=bin/boot.bin