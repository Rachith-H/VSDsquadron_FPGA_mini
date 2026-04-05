# Timer IP — Minimal SoC Timer

## Overview

This is a memory-mapped programmable Timer peripheral IP designed for integration into a RISC-V SoC. It supports one-shot and periodic (auto-reload) countdown modes, with an optional clock prescaler for longer timeout intervals. The IP is written in synchronous Verilog and follows the common memory-mapped register interface used across all peripherals in this SoC.

---

<details>
  <summary> STEP - 1 : RTL design of Timer IP </summary>
  
### Overview

The Timer operates as a **down counter**:

- A value is written into the `LOAD` register  
- When enabled (`EN = 1`), the timer starts decrementing  
- The current value is reflected in the `VALUE` register  
- When the counter reaches zero:
  - A `TIMEOUT` flag is set in the `STATUS` register  
  - Based on mode:
    - **One-shot mode**: Timer stops at zero  
    - **Periodic mode**: Timer reloads from `LOAD` and continues  

A **prescaler** is used to divide the clock, allowing slower and more controllable timing intervals.

---

### Register Map

**Base Address:** `0x00400010`

All registers are 32-bit, word-aligned. Reads from undefined offsets return `0`. Writes to undefined offsets are ignored.

| Offset | Name   | Access | Description                        |
|--------|--------|--------|------------------------------------|
| 0x00   | CTRL   | R/W    | Control: enable, mode, prescaler   |
| 0x04   | LOAD   | R/W    | Countdown start value              |
| 0x08   | VALUE  | R      | Current countdown value (live)     |
| 0x0C   | STATUS | R/W    | Timeout flag; write-1-to-clear     |

---

### CTRL — Control Register (`0x00`)

| Bits    | Field     | Description                                          |
|---------|-----------|------------------------------------------------------|
| [0]     | EN        | 1 = enable counting, 0 = stop                        |
| [1]     | MODE      | 0 = one-shot, 1 = periodic (auto-reload)             |
| [2]     | PRESC_EN  | 1 = prescaler enabled, 0 = no prescale               |
| [15:8]  | PRESC_DIV | Prescaler divide value; actual divisor = PRESC_DIV+1 |
| others  | —         | Reserved, read as 0                                  |

---

### LOAD — Load Register (`0x04`)

32-bit countdown start value. When the timer is enabled (EN=1), the counter loads from this register. In periodic mode, it reloads from this register automatically on each timeout.

---

### VALUE — Current Value Register (`0x08`)

Read-only. Reflects the live countdown value as it decrements toward zero. Does not include write access.

---

### STATUS — Status Register (`0x0C`)

| Bits | Field   | Description                                              |
|------|---------|----------------------------------------------------------|
| [0]  | TIMEOUT | Set to 1 when countdown reaches 0. Write 1 to clear.    |
| others | —     | Reserved, read as 0                                      |

---

## Functional Behavior

1. **Starting the timer:** Software writes a value to `LOAD`, then sets `EN=1` in `CTRL`. The counter begins decrementing from `LOAD` each clock cycle (or each prescaled tick if `PRESC_EN=1`).

2. **Timeout:** When `VALUE` reaches 0, the `TIMEOUT` bit in `STATUS` is set. Software polls this bit to detect expiry.

3. **One-shot mode (`MODE=0`):** The timer stops at zero. `VALUE` holds at 0. Software must reload and re-enable for the next countdown.

4. **Periodic mode (`MODE=1`):** On timeout, `VALUE` automatically reloads from `LOAD` and counting continues without software intervention. `TIMEOUT` is still set each cycle for software to observe.

5. **Prescaler:** When `PRESC_EN=1`, the counter decrements once every `(PRESC_DIV+1)` clock cycles, allowing much longer timeouts without requiring large `LOAD` values.

6. **Clearing TIMEOUT:** Write `1` to bit 0 of `STATUS` to clear the flag (write-1-to-clear semantics).

</details>



<details>
  <summary> STEP - 2 : Integration of Timer IP into SoC </summary>
  

## SoC Integration

The Timer IP is integrated into `riscv.v`. Address decoding uses the upper bits of `mem_addr` to select the peripheral, and the lower bits (`mem_addr[3:2]`) select the register offset within the IP.

The relevant signals connected from the SoC bus to the Timer IP are:

- `mem_addr[31:0]` — address bus
- `mem_wdata[31:0]` — write data
- `mem_rdata[31:0]` — read data (muxed with other peripherals)
- `mem_wen` — write enable
- `clk`, `resetn` — clock and active-low reset

The base address `0x00400010` places the Timer in the peripheral address window. Decoding checks that the upper address bits match the base, then routes offset `[3:2]` to select CTRL, LOAD, VALUE, or STATUS.

---

## Software Validation

Three separate C firmware files were written to validate each operating mode independently. Each program directly reads and writes the memory-mapped registers using volatile pointer accesses, with no UART dependency — pass/fail is confirmed through `$display` output in the simulation testbench.

- **`test_oneshot.c`** — Programs a LOAD value, enables the timer in one-shot mode, polls `STATUS.TIMEOUT`, then clears the flag and verifies the counter has stopped.
- **`test_periodic.c`** — Enables periodic mode and observes multiple successive timeouts without software reload, confirming auto-reload behavior.
- **`test_prescaler.c`** — Enables the prescaler with a chosen `PRESC_DIV` value and verifies that the timeout occurs after the expected number of clock cycles.

---

## Simulation

Simulation was performed using **iverilog + vvp**, with waveforms viewed in **GTKWave**. The testbench instantiates the full SoC (`riscv.v`) and drives the RISC-V core with compiled firmware hex files. All three modes were simulated and confirmed working.

Key simulation notes:
- All source files include `` `timescale 1ns/1ps `` to ensure clock delays are interpreted correctly.
- Reset is active-low (`resetn`); the reset counter in `clockworks.v` was reduced to speed up simulation boot time.
- Validation output is visible via `$display` statements in the testbench.

---

## Reset Behavior

The IP uses an active-low synchronous reset (`resetn`). On reset, all registers return to their default state: `CTRL=0`, `LOAD=0`, `VALUE=0`, `STATUS=0`. The timer does not count while in reset.
