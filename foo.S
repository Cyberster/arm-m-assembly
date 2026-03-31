// SysTick configuration registers
// https://developer.arm.com/documentation/dui0552/a/cortex-m3-peripherals/system-timer--systick/systick-control-and-status-register
.equ SYST_CSR, 0xE000E010       // SysTick Control and Status Register
.equ SYST_RVR, 0xE000E014       // SysTick Reload Value Register
.equ SYST_CVR, 0xE000E018       // SysTick Current Value Register
.equ SYST_TIMEOUT, 0x00FFFFFF //0x00FFFFFF   // SysTick Calibration Value Register

.section .vectors
vector_table:
    .word 0x20005000 //0x20001000
    .word reset_handler
    // https://developer.arm.com/documentation/dui0552/a/the-cortex-m3-processor/exception-model/vector-table
.org 0x3C
    .word systick_handler
    .zero 400

    .section .text
    .align 1
    .type reset_handler, %function
reset_handler:
    ldr r0, =SYST_CSR
    ldr r1, =SYST_RVR
    ldr r2, =SYST_CVR
    ldr r3, =SYST_TIMEOUT // r3 is temp variable

    // initially reload with 0x00FFFFFF, treat this as threshold register
    str r3, [r1]

    // load 0 to systick counter register; good practise as default initial value is unknown
    mov r3, #0x0 // write any value to SYST_CVR will reset it to 0
    str r3, [r2]

    // set ENABLE, TICKINT, and CLKSOURCE flags
    mov r3, #0x7 // 0b00000111
    str r3, [r0]

    mov r5, #0

    // GPIO Config start
    // RCC->APB2ENR i.e. - 0x40021018
    ldr r0, =0x40021018     // Load the address 0x40021018 into R0
    ldr r1, [r0]            // Load the value at the address in R0 into R1
    mov r4, #1              // temp = 1 to be shifted
    lsl r4, r4, #4          // r4 = r3 << 4 as IOPCEN = bit 4
    orr r1, r1, r4          // R1 = R1 | 0x02
    str r1, [r0]            // Store modified register value to r0 i.e. - 0x40023830

    // configure GPIOC_CRH for PC13
    // set mode13 b1 = 1
    ldr r0, =0x40011004
    ldr r1, [r0]
    mov r4, #1
    lsl r4, r4, #21
    orr r1, r1, r4
    str r1, [r0]

    // set mode13 b0 = 0
    ldr r0, =0x40011004
    ldr r1, [r0]
    mov r4, #1
    lsl r4, r4, #20
    mvn r4, r4              // r4 = ~r4 (Complement r4 and store in r4)
    and r1, r1, r4          // r1 = R1 & r4
    str r1, [r0]

    // set cnf13 b1 = 0
    ldr r0, =0x40011004
    ldr r1, [r0]
    mov r4, #1
    lsl r4, r4, #23
    mvn r4, r4              // r4 = ~r4 (Complement r4 and store in r4)
    and r1, r1, r4          // r1 = R1 & r4
    str r1, [r0]

    // set cnf13 b0 = 0
    ldr r0, =0x40011004
    ldr r1, [r0]
    mov r4, #1
    lsl r4, r4, #22
    mvn r4, r4              // r4 = ~r4 (Complement r4 and store in r4)
    and r1, r1, r4          // r1 = R1 & r4
    str r1, [r0]

    bl .

    .section .text
    .align 1 // 2^1
    .type systick_handler, %function
systick_handler:
    add r5, r5, #1

    // GPIOC->ODR |= (1U << 13);  // 0x4001100C
    ldr r0, =0x4001100C
    ldr r1, [r0]
    mov r4, #1
    lsl r4, r4, #13
    eor r1, r1, r4          // R1 = R1 ^ r4
    str r1, [r0]

break_here:
    bx lr

/** Notes:
 *  https://www.youtube.com/watch?v=socXAnsMSmM&list=PLTbERlX_4R01fR_F1giTebJuAUwEd9IsM&index=16
 *  x/4 0x20001000 - 12 // to print the stack
 *  ni ni ni
 *  break break_here
 * c
 */
// comment