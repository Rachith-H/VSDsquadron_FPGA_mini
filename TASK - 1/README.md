#  TASK - 1 : Environment Setup & RISC-V Reference Bring-Up
---
## Objective
Set up the development environment and successfully run a working RISC-V reference design, followed by running the VSDFPGA labs on the same environment.
This task focuses on:
 - Toolchain readiness
 - Understanding the RISC-V execution flow
 - Preparing for upcoming FPGA and IP development work

This task does not use any hardware.

---

<details>
  <summary> STEP - 1 : Setting up GitHub Codespace  </summary>

In this step, the development environment is set up using GitHub Codespaces to ensure a consistent and pre-configured workspace for the VSD FPGA Mini Program.

1. Fork the repository at ` https://github.com/vsdip/vsd-riscv2 ` to your GitHub account.

![fork1](Images/fork1.png)

2. Navigate to the repository and click on the “Code” button and select the “Codespaces” tab and create a new Codespace instance.

![fork2](Images/fork2.png) 

3. Wait for the environment to initialize, all required dependencies and tools will be automatically configured.
The window appears as shown below.

![fork3](Images/fork3.png) 

4. Once the Codespace is ready, open the terminal and verify the setup, by checking the versions of the available tools.
```
riscv64-unknown-elf-gcc --version
spike -help
iverilog -V
```

![fork4](Images/fork4.png) 
![fork5](Images/fork5.png) 
![fork6](Images/fork6.png) 
</details>

<details>
  <summary> STEP - 2 : Verifying the RISC-V Reference Flow </summary>  

In this step, the basic RISC-V software flow is verified by compiling and simulating C programs using the `riscv64-unknown-elf-gcc` toolchain.

1. Navigate to the samples directory containing the sample program.
Compile the provided sum1ton.c program using the RISC-V GCC compiler.
Generate the executable and simulate it in spike to observe the output.
```
cd samples/
riscv64-unknown-elf-gcc -o sum1ton.o sum1ton.c
spike pk sum1ton.o
```

![fork7](Images/fork7.png)  

After verifying the sample program, a custom C program is implemented:

2. Write a simple C program to convert kilometers to meters as shown below.
Compile the program using the RISC-V GCC compiler.
Run the compiled file and simulate it in spike to observe the output.

```
touch kmtom.c
code kmtom.c

riscv64-unknown-elf-gcc -o kmtom.o kmtom.c
spike pk kmtom.o
```
```

#include <stdio.h>

int main() {
    float km, meters;

    // enter kilometer value
    scanf("%f", &km);

    meters = km * 1000;

    printf("Distance in meters = %.2f\n", meters);

    return 0;
}

```

![fork8](Images/fork8.png)   
![fork9](Images/fork9.png)   

Now the same compilation and simulation workflow is performed using the graphical Linux environment available within GitHub Codespaces. 

3. In your Codespace, click the PORTS tab.
Look for the forwarded port named noVNC Desktop (6080).
Click the Forwarded Address link.

![vnc1](Images/novnc1.png)   

4. A new browser tab opens with a directory listing. Click vnc_lite.html.

![vnc2](Images/novnc2.png)   

5. The Linux desktop appears in your browser.
Right-click anywhere on the desktop background.
Select Open Terminal.

![vnc3](Images/novnc3.png)    

6. Navigate to the samples directory containing the sample program.
Compile the provided sum1ton.c program using the native GCC tool and then also using the RISC-V GCC compiler.
Generate the executable and simulate it in spike to observe the output.
```
cd /workspaces/vsd-riscv2/
cd samples/

gcc sum1ton.c
./a.out

riscv64-unknown-elf-gcc -o sum1ton.o sum1ton.c
spike pk sum1ton.o

gcc kmtom.c
./a.out

riscv64-unknown-elf-gcc -o kmtom.o kmtom.c
spike pk kmtom.o
```

![vnc4](Images/novnc4.png)      

![vnc5](Images/novnc5.png)  


7. Further, edit the `sum1ton.c` file , say n = 12 and rerun using the same commands.
```
gedit sum1ton.c
riscv64-unknown-elf-gcc -o sum1ton.o sum1ton.c
spike pk sum1ton.o
```
![vnc6](Images/novnc6.png)   

![vnc7](Images/novnc7.png)  
</details>

<details>
  <summary>  STEP - 3 : Running Basic VSDFPGA Labs </summary>


In this step, a program originally intended for FPGA execution is tested using software based simulation without using actual hardware.

1. Clone the repository `https://github.com/vsdip/vsdfpga_labs.git`. Navigate to the proper directory.

```
git clone https://github.com/vsdip/vsdfpga_labs.git
cd vsdfpga_labs/basicRISCV/Firmware
```

![vnc9](Images/novnc9.png)  

 2. Now compile the `riscv_logo.c` program using native GCC and also using the RISC-V GCC compiler

```
gcc riscv_logo.c
./a.out

riscv64-unknown-elf-gcc -o riscv_logo.o riscv_logo.c
spike pk riscv_logo.o
```

![vnc10](Images/novnc10.png)    

![vnc11](Images/novnc11.png)  

![vnc12](Images/novnc12.png)  

![vnc13](Images/novnc13.png)   


</details>

<details>
  <summary> STEP - 4 : Local Machine Preparation  </summary>  

The required toolchains are installed to support compilation and simulation workflows. This includes:

 - Native GCC compiler for standard program execution
 - RISC-V cross-compiler (riscv64-unknown-elf-gcc) for generating RISC-V binaries
 - Spike along with Proxy Kernel (pk) for RISC-V simulation
 - Icarus Verilog (iverilog) for HDL simulation


</details>

---

## Undersatnding Check

**1. Where is the RISC-V program located in the vsd-riscv2 repository?**

=> The RISC-V C-code programs are located in the `samples` directory of `vsd-riscv2` repository.

**2. How is the program compiled and loaded into memory?**

=> The program is compiled using the `riscv64-unknown-elf-gcc` cross-compiler into an ELF file. It is loaded into the simulated memory by the Spike ISA Simulator, which places the instructions at the base address defined in the linker script.

**3. How does the RISC-V core access memory and memory-mapped IO?**

=> The core uses standard Load/Store instructions. It treats both physical memory and hardware peripherals as specific hexadecimal addresses within a unified address space.

**4. Where would a new FPGA IP block logically integrate in this system?**

=> A new IP block integrates as a Memory-Mapped IO on the System Bus. It sits alongside the memory and other peripherals, the RISC-V core communicates with it by reading from or writing to the specific MMIO address range assigned to that IP in the system's address map.

---
## Environment used 

 - GitHub Codespace on windows.
 - Local setup through virtual machine.



