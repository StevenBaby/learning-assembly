
OUTPUT:= ./output

define mkdirs
	mkdir -p $1
endef

ASFLAGS:= -gstabs  -32 
LDFLAGS:= -m elf_i386

.PHONY:app
app: $(OUTPUT)/cpuid
	cp $< $(OUTPUT)/app

%: %.o
	$(call mkdirs,$(dir $@))
	ld $(LDFLAGS) $< -o $@

$(OUTPUT)/%.o: %.s
	$(call mkdirs,$(dir $@))
	as $(ASFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -rf $(OUTPUT)

.PHONY:debug
debug: app
	gdb $(OUTPUT)/app

