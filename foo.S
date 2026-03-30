// SysTick configuration registers
// https://developer.arm.com/documentation/dui0552/a/cortex-m3-peripherals/system-timer--systick/systick-control-and-status-register
.equ SYST_CSR, 0xE000E010       // SysTick Control and Status Register
.equ SYST_RVR, 0xE000E014       // SysTick Reload Value Register
.equ SYST_CVR, 0xE000E018       // SysTick Current Value Register
.equ SYST_TIMEOUT, 0x000000FF //0x00FFFFFF   // SysTick Calibration Value Register

.section .vectors
vector_table:
    .word 0x20001000
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

    bl .

    .section .text
    .align 1 // 2^1
    .type systick_handler, %function
systick_handler:
    add r5, r5, #1
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