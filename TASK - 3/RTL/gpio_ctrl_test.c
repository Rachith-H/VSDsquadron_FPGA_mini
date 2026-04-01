/*
 * Task-3: GPIO Control IP - Direct Simulation Test
 *
 * Address Map:
 *   GPIO_DATA = 0x00400000
 *   GPIO_DIR  = 0x00400004
 *   GPIO_READ = 0x00400008
 *
 * Testbench: drive GPIO_ext_pins = 0x12340000
 * DIR = 0x0000FFFF → lower 16 = output, upper 16 = input
 */

#define GPIO_DATA  (*(volatile unsigned int *)0x00400000)
#define GPIO_DIR   (*(volatile unsigned int *)0x00400004)
#define GPIO_READ  (*(volatile unsigned int *)0x00400008)
#define LEDS       (*(volatile unsigned int *)0x00400010)

int main() {

    unsigned int read_data_reg;
    unsigned int read_read_reg;

    // Step 1: Write GPIO_DATA first
    GPIO_DATA = 0xA5A5A5A5;

    // Step 2: Set direction
    // lower 16 = output (1), upper 16 = input (0)
    GPIO_DIR = 0x0000FFFF;

    // Step 3: Read GPIO_DATA register
    // Expected: 0xA5A5A5A5 (unaffected by direction)
    read_data_reg = GPIO_DATA;

    // Step 4: Read GPIO_READ register
    // lower 16 → from GPIO_DATA = 0xA5A5
    // upper 16 → from ext_pins  = 0x1234
    // Expected: 0x1234A5A5
    read_read_reg = GPIO_READ;

    // Show result on LEDs (lower 5 bits)
    LEDS = read_read_reg & 0x1F;

    while(1);
    return 0;
}
