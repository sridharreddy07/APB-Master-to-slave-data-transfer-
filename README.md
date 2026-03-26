APB protocol 
🔷 What is APB?

APB (Advanced Peripheral Bus) is part of the ARM AMBA family.

👉 It is used for:

Low-speed peripherals
Simple control/status registers

Examples:

UART
Timer
GPIO
🔑 Key APB Signals
From Master → Slave
PSEL → Select slave
PENABLE → Indicates ACCESS phase
PWRITE → 1 = Write, 0 = Read
PADDR → Address
PWDATA → Write data
From Slave → Master
PRDATA → Read data
PREADY → Slave ready
PSLVERR → Error (optional)
🔥 APB Transfer Protocol (VERY IMPORTANT)

APB works in 2 phases only:

🟡 1. SETUP Phase
PSEL = 1
PENABLE = 0

👉 Master sets:

Address
Write/Read control
Write data (if write)

🔵 2. ACCESS Phase
PSEL = 1
PENABLE = 1

👉 This is the actual transfer phase

If WRITE → slave captures data
If READ → slave drives PRDATA

👉 Transfer completes only when:

PSEL = 1 AND PENABLE = 1 AND PREADY = 1

Two-phase protocol
Always SETUP → ACCESS

Signals stable during ACCESS

During:

PSEL = 1, PENABLE = 1

👉 These must NOT change:
PADDR
PWRITE
PWDATA


code part
when on reset phase everything becomes zero
and STATE = IDLE
on every posedge the code will parse each and every module 
if (PSEL && PENABLE && PWRITE) begin
write can happen

if (PSEL && PENABLE && !PWRITE) begin
Read can happen
make sure Psel & Penable pins must be high during Pdata and Prdata after that we dont care when acces phase is done.
please observe logic input and output for master and slave in DUT which acts like wire.
