# MicroBlaze MCS "Vanilla" SOC System

A modular System-on-Chip (SoC) architecture based on the Xilinx MicroBlaze MCS, featuring a custom MMIO (Memory-Mapped I/O) subsystem for hardware-software co-design.

## 🏗 Hardware Architecture
The system utilizes a "Vanilla" configuration, providing essential peripherals connected via a custom bridge to the MicroBlaze processor.

### Core Components
* **Processor:** Xilinx MicroBlaze MCS (with Debug Module enabled).
* **Interconnect:** `chu_mcs_bridge.sv` (Interface between MCS and MMIO bus).
* **Controller:** `chu_mmio_controller.sv` (Address decoding and data routing for peripherals).

### Peripherals (MMIO Subsystem)
| Module | File(s) | Function | Default Slot |
| :--- | :--- | :--- | :--- |
| **Timer** | `chu_timer.sv` | 48-bit system timer for `sleep_ms()` | Slot 0 |
| **UART** | `uart.sv`, `baud_gen.sv`, `fifo.sv` | Serial communication (Default: 9600 baud) | Slot 1 |
| **GPO** | `chu_gpo.sv` | General Purpose Output (6 x LEDs) | Slot 2 |
| **GPI** | `chu_gpi.sv` | General Purpose Input (16 x Switches) | Slot 3 |

### Note
Defualt Clocking wizard expects `200MHz` input diffrenetial clock, and provides `100MHz` output single ended clock for MCS and MMIO SS.

## 📁 Directory Structure
```text
├── include/
│   └── chu_pkg.sv          # Global parameters, constants, and type definitions
└── src/
    ├── mcs_top_vanilla.sv  # Top-level entity (Wraps MCS and MMIO System)
    ├── mmio_sys_vanilla.sv # Structural wiring of all IO peripherals
    ├── uart_tx.sv/rx.sv    # Low-level UART transmission logic
    ├── fifo_ctrl.sv        # Buffer management for UART/Data streams
    └── register_file.sv    # Internal storage for complex peripherals