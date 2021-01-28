BOOT:= ./boot
BUILD:= ./build

ASM=nasm

.PHONY: clean

$(BUILD)/boot.bin: boot.asm
	$(ASM) boot.asm -o $(BUILD)/boot.bin

$(BUILD)/onix.img: $(BUILD)/boot.bin
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=$< of=$(BUILD)/$@ bs=512 count=1 conv=notrunc

$(BUILD)/harddisk.img: $(BUILD)/boot.bin
	yes yes | bximage -q -hd=64 -mode=create -sectsize=512 -imgmode=flat $@
	dd if=$< of=$@ bs=512 count=1 conv=notrunc

bochs: $(BUILD)/harddisk.img
	-
	cd $(BUILD) && bochs -q

clean:
	rm -rf $(BUILD)/onix.img
	rm -rf $(BUILD)/boot.bin
	rm -rf $(BUILD)/*.o
	rm -rf $(BUILD)/*.a
