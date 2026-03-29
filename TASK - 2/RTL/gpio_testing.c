// Based on One-Hot Address: Word Bit 3 -> 0x00400020
#define GPIO_REG *((volatile unsigned int*)0x00400020)

void _start(void) {
    // 1. Write a distinct pattern to the IP
    // this value appears in GTKWave on the GPIO_reg signal
    GPIO_REG = 0xDEADE123;

    // 2. Read it back into a local variable
    // This will trigger the 'assign IP_rdata' logic in Verilog
    volatile unsigned int read_data;
    read_data = GPIO_REG;

    // 3. Write a different value to show the test is finished
    GPIO_REG = 0x5555AAAA;

    // Halt the processor
    while(1);
}
