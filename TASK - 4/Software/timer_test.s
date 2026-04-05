.section .text
.globl _start

_start:
    # Build address 0x00400010 using lui + addi
    # lui loads upper 20 bits, addi adds lower 12 bits
    # 0x00400010 = upper: 0x00400, lower: 0x010

    lui  t0, 0x400          # t0 = 0x00400000
    addi t0, t0, 16         # t0 = 0x00400010  (TIMER_CTRL)

    # Write TIMER_LOAD = 4  (CTRL + 4 = 0x00400014)
    addi t1, zero, 4
    sw   t1, 4(t0)          # MEM[0x00400014] = 4

    # Write TIMER_CTRL = 0x3  (EN=1, MODE=1 periodic, PRESC=0)
    addi t1, zero, 3
    sw   t1, 0(t0)          # MEM[0x00400010] = 3

spin:
    j spin                  # hang forever, timer runs on its own
