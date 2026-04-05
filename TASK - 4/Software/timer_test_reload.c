#include <stdint.h>

// Assuming IO_TIMER_bit is 2 (Address 0x00400008 based on word indexing)
// Adjust the base address if your localparam differs
#define TIMER_BASE   0x00400010 
#define TIMER_CTRL   (*(volatile uint32_t*)(TIMER_BASE + 0x00))
#define TIMER_LOAD   (*(volatile uint32_t*)(TIMER_BASE + 0x04))
#define TIMER_VALUE  (*(volatile uint32_t*)(TIMER_BASE + 0x08))
#define TIMER_STATUS (*(volatile uint32_t*)(TIMER_BASE + 0x0C))

int main() {
    // 1. Set Load Value (e.g., 1000 cycles)
    TIMER_LOAD = 13;

    // 2. Configure: Enable=1, Mode=0 (One-Shot), Prescaler=0
    TIMER_CTRL = 0x00000003;

    // 3. Poll for Timeout
    while(!(TIMER_STATUS & 0x01));

    // 4. Clear Timeout Flag (Write-1-to-Clear)
    TIMER_STATUS = 0x01;

    // 5. Verify EN bit is auto-cleared (One-Shot check)
    if (TIMER_CTRL & 0x01) {
        // Error: Timer did not stop
    }

    // Finish simulation
    asm volatile ("ebreak");
    return 0;
}
