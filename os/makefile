BOOT:= ./boot
BUILD:= ./build

ASM=nasm

.PHONY: clean test

$(BUILD)/harddisk.img:
ifeq ("$(wildcard $(BUILD)/harddisk.img)", "")
	bximage -q -hd=16 -mode=create -sectsize=512 -imgmode=flat $@
endif
	# dd if=$(BUILD)/boot.bin of=$@ bs=512 count=1 conv=notrunc
	# dd if=$(BUILD)/kernel.bin of=$@ bs=512 seek=1 conv=notrunc
	# dd if=$(BUILD)/app.bin of=$@ bs=512 seek=100 conv=notrunc

bochs: $(BUILD)/harddisk.img
	@rm -rf $(BUILD)/harddisk.img.lock
	cd $(BUILD) && bochs -q

clean:
	rm -rf $(BUILD)/harddisk.img*

