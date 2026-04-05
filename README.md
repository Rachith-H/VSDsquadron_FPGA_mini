# VSDsquadron FM Research Internship

This program is part of the VSD FPGA IP Development cohort, designed to transition participants from environment setup to real IP ownership and contribution. The program follows a structured, hands-on approach where each participant designs, integrates, validates, and documents memory-mapped peripheral IPs on a RISC-V SoC. The target platform is the VSDSquadron FPGA board based on the Lattice iCE40, and the SoC is built around a minimal RISC-V processor core.

---

## Task 1 — Environment Setup & RISC-V Reference Bring-Up

- Forked and launched the vsd-riscv2 GitHub Codespace
- Built and ran the RISC-V reference program successfully
- Cloned and ran vsdfpga_labs inside the same Codespace
- Set up local development environment using the Dockerfile as reference

---

## Task 2 — Simple GPIO Output IP

- Designed a single-register 32-bit write/read GPIO IP
- Integrated into the RISC-V SoC using 1-hot address decoding
- Connected IP to CPU bus signals — mem_wdata, mem_wstrb, mem_rdata
- Validated read/write behaviour through simulation $display output and GTKWave waveforms

---

## Task 3 — Multi-Register GPIO Control IP

- Extended GPIO IP to 3 registers — GPIO_DATA, GPIO_DIR, GPIO_READ
- Implemented offset-based register decoding using mem_addr[3:2]
- GPIO_DIR controls direction per bit — 1 = output, 0 = input
- GPIO_READ reflects driven value for output pins and external pin state for input pins
- Validated through direct waveform inspection in simulation

---

## Task 4 — Timer IP (Core Contributor)

- Designed a full programmable countdown Timer IP from scratch with 4 registers — CTRL, LOAD, VALUE, STATUS
- Supports one-shot and periodic auto-reload modes
- Configurable prescaler for clock division via CTRL bits
- Timer runs autonomously once configured — independent of CPU activity
- Firmware written in RISC-V assembly for direct hardware control
- Successfully validated on VSDSquadron FPGA board — LED visibly toggles on every timeout

---

## Conclusion

Across these four tasks, the complete lifecycle of FPGA IP development was covered — from understanding the SoC bus architecture and memory-mapped IO, to designing increasingly complex peripherals, integrating them into a live RISC-V system, writing firmware to control them, and validating behaviour both in simulation and on real hardware. The program builds the foundational skills needed for real-world peripheral IP development, including register map design, synchronous RTL coding, address decoding, software-hardware contracts, and end to end debugging.




