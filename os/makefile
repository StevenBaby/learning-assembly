BUILD:= ./build
SRC:=./src

BOOT_INC:=$(SRC)/boot

ASM=nasm

ASM_FLAGS= -f bin

.PHONY: clean test

$(BUILD)/boot.bin: $(SRC)/boot/boot.asm $(BOOT_INC)/boot.inc
	$(ASM) -I $(BOOT_INC) $< -o $@

$(BUILD)/loader.bin: $(SRC)/boot/loader.asm $(BOOT_INC)/boot.inc
	$(ASM) $(ASM_FLAGS) -I $(BOOT_INC) $< -o $@

$(BUILD)/harddisk.img: \
	$(BUILD)/boot.bin \
	$(BUILD)/loader.bin
ifeq ("$(wildcard $(BUILD)/harddisk.img)", "")
	bximage -q -hd=16 -mode=create -sectsize=512 -imgmode=flat $@
endif
	dd if=$(BUILD)/boot.bin of=$@ bs=512 count=1 conv=notrunc
	dd if=$(BUILD)/loader.bin of=$@ bs=512 count=20 seek=2 conv=notrunc
	# dd if=$(BUILD)/kernel.bin of=$@ bs=512 seek=1 conv=notrunc
	# dd if=$(BUILD)/app.bin of=$@ bs=512 seek=100 conv=notrunc

bochs: $(BUILD)/harddisk.img
	@rm -rf $(BUILD)/harddisk.img.lock
	cd $(BUILD) && bochs -q -f ../bochsrc

clean:
	rm -rf $(BUILD)/harddisk.img*
	rm -rf $(BUILD)/boot.bin
	rm -rf $(BUILD)/loader.bin


