BOOT:= ./boot
BUILD:= ./build
SRC:=./src

ASM=nasm

ASM_FLAGS= -f elf

.PHONY: clean test

$(BUILD)/boot.bin: $(SRC)/boot/boot.asm
	$(ASM) $< -o $@

$(BUILD)/loader.bin: $(SRC)/boot/loader.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

$(BUILD)/harddisk.img: \
	$(BUILD)/boot.bin \
	$(BUILD)/loader.bin
ifeq ("$(wildcard $(BUILD)/harddisk.img)", "")
	bximage -q -hd=16 -mode=create -sectsize=512 -imgmode=flat $@
endif
	dd if=$(BUILD)/boot.bin of=$@ bs=512 count=1 conv=notrunc
	dd if=$(BUILD)/loader.bin of=$@ bs=512 count=1 seek=1 conv=notrunc
	# dd if=$(BUILD)/kernel.bin of=$@ bs=512 seek=1 conv=notrunc
	# dd if=$(BUILD)/app.bin of=$@ bs=512 seek=100 conv=notrunc

bochs: $(BUILD)/harddisk.img
	@rm -rf $(BUILD)/harddisk.img.lock
	# cd $(BUILD) && bochs -q -f ../bochsrc

clean:
	rm -rf $(BUILD)/harddisk.img*
	rm -rf $(BUILD)/boot.bin
	rm -rf $(BUILD)/loader.bin


