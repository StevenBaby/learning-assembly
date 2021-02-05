BOOT:= ./boot
BUILD:= ./build

ASM=nasm

.PHONY: clean

$(BUILD)/boot.bin: boot.asm
	$(ASM) $< -o $@

$(BUILD)/app.bin: app.asm
	$(ASM) $< -o $@

$(BUILD)/harddisk.img: $(BUILD)/boot.bin $(BUILD)/app.bin
ifeq ("$(wildcard $(BUILD)/harddisk.img)", "")
	bximage -q -hd=64 -mode=create -sectsize=512 -imgmode=flat $@
endif
	dd if=$(BUILD)/boot.bin of=$@ bs=512 count=1 conv=notrunc
	dd if=$(BUILD)/app.bin of=$@ bs=512 seek=100 conv=notrunc


bochs: $(BUILD)/harddisk.img
	-
	@rm -rf $(BUILD)/harddisk.img.lock
	# cd $(BUILD) && bochs -q

clean:
	rm -rf $(BUILD)/onix.img
	rm -rf $(BUILD)/harddisk.img*
	rm -rf $(BUILD)/boot.bin
	rm -rf $(BUILD)/*.o
	rm -rf $(BUILD)/*.a
