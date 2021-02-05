section data0 align=16
    data1_segment dd section.data1.start
    data2_segment dd section.data2.start
    data3_segment dd section.data3.start
    data4_segment dd section.data4.start

section data1 align=16 vstart=0
    db 0x55

section data2 align=16 vstart=0

    db 0xaa

section data3 align=32 vstart=0
    dd 0xaa55

section data4 align=32 vstart=0
    dd 0xaa55