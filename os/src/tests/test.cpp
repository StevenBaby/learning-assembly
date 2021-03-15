#include <elf.h>
#include <iostream>

#pragma pack(1)

typedef struct
{
    unsigned char e_ident[EI_NIDENT]; /* Magic number and other info */
    // Elf32_Half e_type;                /* Object file type */
    // Elf32_Half e_machine;             /* Architecture */
    // Elf32_Word e_version;             /* Object file version */
    // Elf32_Addr e_entry;               /* Entry point virtual address */
    // Elf32_Off e_phoff;                /* Program header table file offset */
    // Elf32_Off e_shoff;                /* Section header table file offset */
    // Elf32_Word e_flags;               /* Processor-specific flags */
    // Elf32_Half e_ehsize;              /* ELF header size in bytes */
    // Elf32_Half e_phentsize;           /* Program header table entry size */
    // Elf32_Half e_phnum;               /* Program header table entry count */
    // Elf32_Half e_shentsize;           /* Section header table entry size */
    // Elf32_Half e_shnum;               /* Section header table entry count */
    // Elf32_Half e_shstrndx;            /* Section header string table index */
} ELFTest;

typedef struct
{
//   Elf32_Word	p_type;			/* Segment type */
//   Elf32_Off	p_offset;		/* Segment file offset */
//   Elf32_Addr	p_vaddr;		/* Segment virtual address */
//   Elf32_Addr	p_paddr;		/* Segment physical address */
//   Elf32_Word	p_filesz;		/* Segment size in file */
//   Elf32_Word	p_memsz;		/* Segment size in memory */
//   Elf32_Word	p_flags;		/* Segment flags */
//   Elf32_Word	p_align;		/* Segment alignment */
} Elf32_Header;

int main()
{
    std::cout << sizeof(Elf32_Header) << std::endl;
}
