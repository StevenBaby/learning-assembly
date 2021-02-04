BOOT:= ./boot
BUILD:= ./build

ASM=nasm

.PHONY: clean

$(BUILD)/boot.bin: boot.asm
	$(ASM) boot.asm -o $(BUILD)/boot.bin

$(BUILD)/harddisk.img: $(BUILD)/boot.bin
ifeq ("$(wildcard $(BUILD)/harddisk.img)", "")
	bximage -q -hd=64 -mode=create -sectsize=512 -imgmode=flat $@
endif
	dd if=$< of=$@ bs=512 count=1 conv=notrunc

bochs: $(BUILD)/harddisk.img
	-
	@rm -rf $(BUILD)/harddisk.img.lock
	cd $(BUILD) && bochs -q

clean:
	rm -rf $(BUILD)/onix.img
	rm -rf $(BUILD)/harddisk.img*
	rm -rf $(BUILD)/boot.bin
	rm -rf $(BUILD)/*.o
	rm -rf $(BUILD)/*.a
