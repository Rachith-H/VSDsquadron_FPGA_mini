# TASK - 3 Designing a Multi-Register GPIO IP with Software Control
---
## Objectives

Extend the simple GPIO IP from Task-2 into a realistic, multi-register, software-controlled IP.
This task focuses on:
- Designing a proper register map.
- Handling multiple registers inside one IP.
- Strengthening understanding of memory-mapped I/O.
- Validating end-to-end control from software to hardware.

---

<details>
  <summary> STEP - 1 : Study and Planning </summary>

### **Overview**

In this step, the objective is to analyze the existing single-register GPIO IP from Task-2 and plan its extension into a multi-register, software-controlled peripheral. 
The focus is on understanding and design preparation.

---

### **1. Understanding the Existing Design**

The GPIO IP developed in Task-2 consists of a single 32-bit register that supports basic read and write operations through memory-mapped I/O. While functional, it lacks flexibility and configurability required in real-world peripherals.

---

### **2. Design Goal for Extension**

The goal is to transform the simple GPIO into a more realistic IP by:

* Supporting multiple registers within a single IP
* Enabling software control over GPIO direction
* Providing a structured register map for organized access

---

### **3. Register Planning**

A register map is defined to organize the functionality of the GPIO IP:

* **GPIO_DATA** → Stores output values written by the processor
* **GPIO_DIR** → Controls direction of each GPIO pin (input/output)
* **GPIO_READ** → Provides readback of GPIO state

Each register is assigned a unique offset from the base address, enabling multiple functionalities within a single IP block.

---

### **4. Address Offset Strategy**

Since the GPIO IP will now contain multiple registers, address offset decoding is required. The lower bits of the address (`mem_addr[3:2]`) are used to differentiate between registers within the same IP.

This allows the processor to access different registers using:

* Base address + offset

---

### **5. Design Considerations**

* Ensure clean synchronous write logic
* Avoid unintended latch generation
* Maintain compatibility with existing SoC integration
* Keep the design modular and scalable

This step establishes a clear design plan for implementing a multi-register GPIO IP. By defining the register map, address decoding strategy, and required signals in advance, the implementation in subsequent steps becomes structured and error-free.

</details>



<details>
  <summary> STEP - 2 : RTL Design of GPIO Control IP </summary>

### **Overview**

In this step, a multi-register [GPIO Control IP](RTL/GPIO_ctrl_IP) is implemented in RTL. The design extends the basic single-register GPIO into a structured peripheral with multiple registers, 
enabling configurable input/output behavior and organized memory-mapped access.

---

### **1. Module Description**

The GPIO Control IP consists of three internal 32-bit registers:

* `GPIO_data` → stores output values written by the processor
* `GPIO_dir` → controls the direction of each GPIO pin
* `GPIO_read` → provides readback data

The IP uses address offset decoding to select the appropriate register for read and write operations.

---

### **2. Signal Description**

| Signal Name     | Direction | Description                                      |
| --------------- | --------- | ------------------------------------------------ |
| `clk`           | Input     | System clock for synchronous operations          |
| `rst`           | Input     | Reset signal to initialize registers             |
| `wen`           | Input     | Write enable signal indicating a write operation |
| `IP_sel`        | Input     | Indicates selection of GPIO IP based on address  |
| `IP_wdata`      | Input     | 32-bit data input from the processor             |
| `IP_rdata`      | Output    | 32-bit data output to the processor              |
| `mem_addr[3:2]` | Input     | Address offset used for register selection       |
| `IP_ext_in`     | Input     | 32-bit data input from external pins             |

---

### **3. Address Offset Decoding**

The lower bits of the address bus (`mem_addr[3:2]`) are used to select between internal registers:

* `2'b00` → GPIO_data
* `2'b01` → GPIO_dir
* `2'b10` → GPIO_read

This allows multiple registers to be accessed using a single base address.

---

### **4. Write Operation**

Write operations are synchronous and occur on the rising edge of the clock. A write is performed only when both the IP is selected and the write enable signal is active.

* Writing to `GPIO_data` updates output values
* Writing to `GPIO_dir` configures pin direction

---

### **5. Read Operation**

Read operations are combinational. The output data is continuously driven based on the selected register and is routed to bus only when IP is selected through control signal.
This ensures immediate response to read requests from the processor.

* Reading from `GPIO_data` returns last written value
* Reading from `GPIO_dir` returns last written direction configuration
* Reading from `GPIO_read` Returns current GPIO pin values,
  * For output pins, reflects driven value
  * For input pins, reflects pin state


---

### **6. Direction Control Logic**

The `GPIO_dir` register determines the mode of each GPIO pin:

* `1` → Output mode
* `0` → Input mode


---

### **7. Design Characteristics**

* Synchronous write logic
* Combinational read logic
* Memory-mapped register interface
* Modular and scalable structure


The GPIO Control IP RTL successfully implements a multi-register, memory-mapped peripheral. The design provides flexibility through direction control and structured register access, forming a foundation for more advanced peripheral designs.



</details>
