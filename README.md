# VSDsquadron_FPGA_mini
Documentation and hands on work from the VSDsquadron FPGA Mini Program, covering RISC-V toolchain setup, and FPGA design flow using open-source tools.

riscv64-unknown-elf-gcc -O0 -nostdlib -march=rv32i -mabi=ilp32 \
-Ttext=0x0 gpio.c -o gpio.elf

riscv64-unknown-elf-objcopy -O binary gpio.elf gpio.bin

hexdump -v -e '1/4 "%08x\n"' gpio.bin > firmware.hex

iverilog -DBENCH -o riscv_tb.vvp riscv.v gpio_ip.v riscv_tb.v

vvp riscv_tb.vvp

gtkwave soc.vcd
