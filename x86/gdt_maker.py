# coding=utf-8

import ctypes


class GDTStructure(ctypes.BigEndianStructure):

    _pack_ = 1
    _fields_ = [
        ('base0', ctypes.c_uint16),
        ('limit0', ctypes.c_uint16),
        ('base2', ctypes.c_uint8),
        ('g', ctypes.c_uint8, 1),
        ('db', ctypes.c_uint8, 1),
        ('l', ctypes.c_uint8, 1),
        ('avl', ctypes.c_uint8, 1),
        ('limit1', ctypes.c_uint8, 4),
        ('p', ctypes.c_uint8, 1),
        ('dpl', ctypes.c_uint8, 2),
        ('s', ctypes.c_uint8, 1),
        ('type', ctypes.c_uint8, 4),
        ('base1', ctypes.c_uint8),
    ]


class GDTMemory(ctypes.BigEndianStructure):

    _pack_ = 1
    _fields_ = [
        ('value', ctypes.c_uint64),
    ]


class GDT(ctypes.Union):

    G_BYTE = 0
    G_4K = 1

    DB_16BIT = 0
    DB_32BIT = 1

    L_32BIT = 0
    L_64BIT = 1

    P_ABSENT = 0
    P_EXISTS = 1

    DPL0 = 0
    DPL1 = 1
    DPL2 = 2
    DPL3 = 3

    S_SYSTEM = 0
    S_MEMORY = 1

    TYPE_XEWA = None
    TYPE_XCRA = None

    _pack_ = 1
    _fields_ = [
        ('struct', GDTStructure),
        ('byte', GDTMemory),
    ]

    def __init__(self):
        self.base = 0
        self.limit = 0

    def make(self):
        self.struct.base0 = self.base & 0xffff
        self.struct.base1 = (self.base & 0xff0000) >> 16
        self.struct.base2 = (self.base & 0xff000000) >> 24
        self.struct.limit0 = self.limit & 0xffff
        self.struct.limit1 = (self.limit & 0xf0000) >> 16

    def print(self):
        print(self.make())


def main():

    descripter = GDT()
    # descripter = GDTStructure()
    # value = 0b10000000_1_1_1_1_0101_1_11_1_1010_00111010
    # value = 0b10000000_0_1_0_0_0000_1_00_1_1000_00000000
    # value = 0b0_1111111_1_1_1_1
    # value = 0x7c0001ff_00409800
    # print(bin(value), hex(value))
    # descripter.byte.value = value

    # print("B2   :", hex(descripter.struct.base2))
    # print("B1   :", hex(descripter.struct.base1))
    # print("B0   :", hex(descripter.struct.base0))
    # print("L1   :", hex(descripter.struct.limit1))
    # print("L0   :", hex(descripter.struct.limit0))

    # print("G    :", hex(descripter.struct.g))
    # print("D/B  :", hex(descripter.struct.db))
    # print("L    :", hex(descripter.struct.l))
    # print("AVL  :", hex(descripter.struct.avl))
    # print("P    :", hex(descripter.struct.p))
    # print("DPL  :", hex(descripter.struct.dpl))
    # print("S    :", hex(descripter.struct.s))
    # print("TYPE :", hex(descripter.struct.type))

    descripter.base = 0x10000
    descripter.limit = 0xffff
    descripter.struct.g = GDT.G_BYTE
    descripter.struct.db = GDT.DB_32BIT
    descripter.struct.l = GDT.L_32BIT
    descripter.struct.p = GDT.P_EXISTS
    descripter.struct.dpl = GDT.DPL0
    descripter.struct.s = GDT.S_MEMORY
    descripter.struct.type = 0b0010  # GDT.TYPE_XEWA
    descripter.make()

    print("GDT  :", hex(descripter.byte.value))

    print(hex(5 << 3 | 0b000))


if __name__ == '__main__':
    main()
