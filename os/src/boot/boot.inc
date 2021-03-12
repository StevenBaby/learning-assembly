BOOT_BASE_ADDR equ 0x7c00

LOADER_BASE_ADDR equ 0x900
LOADER_START_SECTOR equ 0x2

PAGE_DIR_TABLE_ADDR equ 0x100000

                               ;0_0_0_0_0000_0_00_0_0000b
                               ;G_D_L_A_LIMI_P_DP_S_TYPE

GDT_G_BYTE                  equ 0_0_0_0_0000_0_00_0_0000b
GDT_G_4K                    equ 1_0_0_0_0000_0_00_0_0000b

GDT_DB_16                   equ 0_0_0_0_0000_0_00_0_0000b
GDT_DB_32                   equ 0_1_0_0_0000_0_00_0_0000b

GDT_L_32                    equ 0_0_0_0_0000_0_00_0_0000b
GDT_L_64                    equ 0_0_1_0_0000_0_00_0_0000b

GDT_P_ABS                   equ 0_0_0_0_0000_0_00_0_0000b
GDT_P_PRE                   equ 0_0_0_0_0000_1_00_0_0000b

GDT_DPL_0                   equ 0_0_0_0_0000_0_00_0_0000b
GDT_DPL_1                   equ 0_0_0_0_0000_0_01_0_0000b
GDT_DPL_2                   equ 0_0_0_0_0000_0_10_0_0000b
GDT_DPL_3                   equ 0_0_0_0_0000_0_11_0_0000b

GDT_S_SYSTEM                equ 0_0_0_0_0000_0_00_0_0000b
GDT_S_DATA                  equ 0_0_0_0_0000_0_00_1_0000b

GDT_TYPE_DATA               equ 0_0_0_0_0000_0_00_0_0000b
GDT_TYPE_DATA_EXTEND_UP     equ 0_0_0_0_0000_0_00_0_0000b
GDT_TYPE_DATA_EXTEND_DOWN   equ 0_0_0_0_0000_0_00_0_0100b
GDT_TYPE_DATA_WRITE         equ 0_0_0_0_0000_0_00_0_0010b

GDT_TYPE_CODE               equ 0_0_0_0_0000_0_00_0_1000b
GDT_TYPE_CODE_COMPLY        equ 0_0_0_0_0000_0_00_0_0100b
GDT_TYPE_CODE_READ          equ 0_0_0_0_0000_0_00_0_1010b

GDT_TYPE_ACCESS             equ 0_0_0_0_0000_0_00_0_0001b

RPL0    equ 00b
RPL1    equ 01b
RPL2    equ 10b
RPL3    equ 11b
TI_GDT  equ 000b
TI_LDT  equ 100b

; pde explain
; AVL_G_0_D_A_PCD_PWT_US_RW_P

; pte explain
; AVL_G_T_D_A_PCD_PWT_US_RW_P

PG_P    equ 1b ; exists
PG_RW_R equ 00b ; write disable
PG_RW_W equ 10b ; write enable
PG_US_S equ 000b ; system user
PG_US_U equ 100b ; normal user

GDT_CODE_ATTRIBUTE          equ (GDT_G_4K   | GDT_DB_32 | GDT_P_PRE | GDT_S_DATA | GDT_TYPE_CODE_READ)
GDT_DATA_ATTRIBUTE          equ (GDT_G_4K   | GDT_DB_32 | GDT_P_PRE | GDT_S_DATA | GDT_TYPE_DATA_WRITE)
GDT_VIDEO_ATTRIBUTE         equ (GDT_G_BYTE | GDT_DB_32 | GDT_P_PRE | GDT_S_DATA | GDT_TYPE_DATA_WRITE | GDT_DPL_3) 


%macro GDTDescriptor 3; (base_address, limit, attribute)
    dw %2 & 0xffff
    dw %1 & 0xffff
    db (%1 >> 16) & 0xff
    dw ((%2 >> 8) & 0x0f00) | (%3 & 0xf0ff)
    db (%1 >> 24) & 0xff
%endmacro
