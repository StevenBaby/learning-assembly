BOOT:= ./boot
BUILD:= ./build
SRC:=./src
ASM=nasm

.PHONY: clean test

$(BUILD)/mbr.bin: $(SRC)/boot/mbr.asm
	$(ASM) $< -o $@

$(BUILD)/harddisk.img: $(BUILD)/mbr.bin
ifeq ("$(wildcard $(BUILD)/harddisk.img)", "")
	bximage -q -hd=16 -mode=create -sectsize=512 -imgmode=flat $@
endif
	dd if=$(BUILD)/mbr.bin of=$@ bs=512 count=1 conv=notrunc
	# dd if=$(BUILD)/kernel.bin of=$@ bs=512 seek=1 conv=notrunc
	# dd if=$(BUILD)/app.bin of=$@ bs=512 seek=100 conv=notrunc

bochs: $(BUILD)/harddisk.img
	@rm -rf $(BUILD)/harddisk.img.lock
	cd $(BUILD) && bochs -q -f ../bochsrc

clean:
	rm -rf $(BUILD)/harddisk.img*
	rm -rf $(BUILD)/bx_enh_dbg.ini
	rm -rf $(BUILD)/mbr.bin


