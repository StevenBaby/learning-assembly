BUILD:= ./build
SRC:=./src

BOOT_INC:=$(SRC)/boot
INCLUDE:=$(SRC)/kernel/include
KERNEL:=$(SRC)/kernel

BOCHS:=/usr/bin/bochs
ASM=nasm
CC=gcc
LD=ld

ENTRYPOINT = 0xC0010000


ASM_FLAGS= -f bin
ASM_KERNEL_FLAGS= -f elf

CFLAGS = -I $(INCLUDE) -c -fno-builtin -m32 -fno-stack-protector \
		-nostdlib -nostdinc -nostartfiles -nodefaultlibs -Wall -Wextra 

LDFLAGS = -m elf_i386 -s -Ttext $(ENTRYPOINT)


.PHONY: clean test

$(BUILD)/boot.bin: $(SRC)/boot/boot.asm $(BOOT_INC)/boot.inc
	$(ASM) -I $(BOOT_INC) $< -o $@

$(BUILD)/loader.bin: $(SRC)/boot/loader.asm $(BOOT_INC)/boot.inc
	$(ASM) $(ASM_FLAGS) -I $(BOOT_INC) $< -o $@

$(BUILD)/start.o: $(KERNEL)/start.asm
	$(ASM) $(ASM_KERNEL_FLAGS) -I $(BOOT_INC) $< -o $@

$(BUILD)/main.o: $(KERNEL)/main.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD)/kernel.bin: $(BUILD)/start.o \
	$(BUILD)/main.o
	$(LD) $(LDFLAGS) $^ -o $@

$(BUILD)/harddisk.img: \
	$(BUILD)/boot.bin \
	$(BUILD)/loader.bin \
	$(BUILD)/kernel.bin
ifeq ("$(wildcard $(BUILD)/harddisk.img)", "")
	bximage -q -hd=16 -mode=create -sectsize=512 -imgmode=flat $@
endif
	dd if=$(BUILD)/boot.bin of=$@ bs=512 count=1 conv=notrunc
	dd if=$(BUILD)/loader.bin of=$@ bs=512 count=20 seek=2 conv=notrunc
	dd if=$(BUILD)/kernel.bin of=$@ bs=512 seek=100 count=200 conv=notrunc
	# dd if=$(BUILD)/app.bin of=$@ bs=512 seek=100 conv=notrunc

bochs: $(BUILD)/harddisk.img
	@rm -rf $(BUILD)/harddisk.img.lock
	cd $(BUILD) && $(BOCHS) -q -f ../bochsrc

clean:
	rm -rf $(BUILD)/*.o
	rm -rf $(BUILD)/harddisk.img*
	rm -rf $(BUILD)/boot.bin
	rm -rf $(BUILD)/loader.bin
	rm -rf $(BUILD)/kernel.bin


