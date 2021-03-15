ELF_HEADER_OFFSET_TYPE      equ 16;   /* Object file type */
ELF_HEADER_OFFSET_MACHINE   equ 18;  /* Architecture */
ELF_HEADER_OFFSET_VERSION   equ 20;  /* Object file version */
ELF_HEADER_OFFSET_ENTRY     equ 24;  /* Entry point virtual address */
ELF_HEADER_OFFSET_PHOFF     equ 28;  /* Program header table file offset */
ELF_HEADER_OFFSET_SHOFF     equ 32;  /* Section header table file offset */
ELF_HEADER_OFFSET_FLAGS     equ 36;  /* Processor-specific flags */
ELF_HEADER_OFFSET_EHSIZE    equ 40;  /* ELF header size in bytes */
ELF_HEADER_OFFSET_PHENTSIZE equ 42;  /* Program header table entry size */
ELF_HEADER_OFFSET_PHNUM     equ 44;  /* Program header table entry count */
ELF_HEADER_OFFSET_SHENTSIZE equ 46;  /* Section header table entry size */
ELF_HEADER_OFFSET_SHNUM     equ 48;  /* Section header table entry count */
ELF_HEADER_OFFSET_SHSTRNDX  equ 50;  /* Section header string table index */

ELF_PROGRAM_OFFSET_TYPE equ 0;   /* Segment type */
ELF_PROGRAM_OFFSET_OFFSET equ 4;  /* Segment file offset */
ELF_PROGRAM_OFFSET_VADDR equ 8;  /* Segment virtual address */
ELF_PROGRAM_OFFSET_PADDR equ 12;  /* Segment physical address */
ELF_PROGRAM_OFFSET_FILESZ equ 16;  /* Segment size in file */
ELF_PROGRAM_OFFSET_MEMSZ equ 20;  /* Segment size in memory */
ELF_PROGRAM_OFFSET_FLAGS equ 24;  /* Segment flags */
ELF_PROGRAM_OFFSET_ALIGN equ 28;  /* Segment alignment */
