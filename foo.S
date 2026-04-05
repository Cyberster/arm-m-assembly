// SysTick configuration registers
// https://developer.arm.com/documentation/dui0552/a/cortex-m3-peripherals/system-timer--systick/systick-control-and-status-register
.equ SYST_CSR, 0xE000E010       // SysTick Control and Status Register
.equ SYST_RVR, 0xE000E014       // SysTick Reload Value Register
.equ SYST_CVR, 0xE000E018       // SysTick Current Value Register
.equ SYST_TIMEOUT, 0x00FFFFFF //0x00FFFFFF   // SysTick Calibration Value Register

.section .vectors
vector_table:
    .word 0x20005000 //0x20001000 // SP
    .word reset_handler
    // https://developer.arm.com/documentation/dui0552/a/the-cortex-m3-processor/exception-model/vector-table
.org 0x3C // address of systick_handler is 0x3C (60 in decimal) bytes from the start of the vector table
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

    // load 0 to systick counter register - good practise as default initial value is unknown
    mov r3, #0x0 // write any value to SYST_CVR will reset it to 0
    str r3, [r2]

    // set ENABLE, TICKINT, and CLKSOURCE flags
    mov r3, #0x7 // 0b00000111
    str r3, [r0]

    mov r5, #0
    mov r6, #0

    // GPIO Config start
    // RCC->APB2ENR i.e. - 0x40021018
    ldr r0, =0x40021018     // Load the address 0x40021018 into R0
    ldr r1, [r0]            // Load the value at the address in R0 into R1
    mov r4, #1              // temp register r4 = 1 to be shifted
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

    // set mode13 b0 = 0
    mov r4, #1
    lsl r4, r4, #20
    mvn r4, r4              // r4 = ~r4 (Complement r4 and store in r4)
    and r1, r1, r4          // r1 = R1 & r4

    // set cnf13 b1 = 0]
    mov r4, #1
    lsl r4, r4, #23
    mvn r4, r4              // r4 = ~r4 (Complement r4 and store in r4)
    and r1, r1, r4          // r1 = R1 & r4 

    // set cnf13 b0 = 0
    mov r4, #1
    lsl r4, r4, #22
    mvn r4, r4              // r4 = ~r4 (Complement r4 and store in r4)
    and r1, r1, r4          // r1 = R1 & r4

    str r1, [r0]





    // RCC->APB2ENR i.e. - 0x40021018
    ldr r0, =0x40021018     // Load the address 0x40021018 into R0
    ldr r1, [r0]            // Load the value at the address in R0 into R1
    mov r4, #1              // temp register r4 = 1 to be shifted
    lsl r4, r4, #2          // r4 = r3 << 2 as IOPAEN = bit 2
    orr r1, r1, r4          // R1 = R1 | 0x02
    str r1, [r0]            // Store modified register value to r0 i.e. - 0x40023830

    // configure GPIOC_CRH for PC13
    // set mode13 b1 = 1
    ldr r0, =0x40010800
    ldr r1, [r0]
    mov r4, #1
    lsl r4, r4, #21
    orr r1, r1, r4

    // set mode13 b0 = 0
    mov r4, #1
    lsl r4, r4, #20
    mvn r4, r4              // r4 = ~r4 (Complement r4 and store in r4)
    and r1, r1, r4          // r1 = R1 & r4

    // set cnf13 b1 = 0]
    mov r4, #1
    lsl r4, r4, #23
    mvn r4, r4              // r4 = ~r4 (Complement r4 and store in r4)
    and r1, r1, r4          // r1 = R1 & r4 

    // set cnf13 b0 = 0
    mov r4, #1
    lsl r4, r4, #22
    mvn r4, r4              // r4 = ~r4 (Complement r4 and store in r4)
    and r1, r1, r4          // r1 = R1 & r4

    str r1, [r0]




    // 0x20001000   linked list head (pointer to current task)
    // 0x20001100   task_a stack frame
    // 0x20001200   task_b stack frame

head:
    // Set data value of node A
    ldr r0, =task_a         //@ Load the address of 'task_a' into R0
    ldr r1, =0x20001000     // load address of node A into r1
    str r0, [r1]            //@ Store the address of 'task_a' at 0x30000100
    
    // next pointer of node A
    ldr r0, =0x20001004 // here to be stored
    ldr r1, =0x20001008 // this to be stored
    str r1, [r0]
    
    // Set data value of node B    
    ldr r0, =task_b  //@ Load the address of 'task_a' into R0
    ldr r1, =0x20001008
    str r0, [r1]     //@ Store the address of 'task_a' at 0x30000100
    
    // next pointer of node B
    ldr r0, =0x2000100c // here to be stored
    ldr r1, =0x20001000 // this to be stored
    str r1, [r0]
    
    // Set head pointer to node A
    ldr r0, =0x20001010
    ldr r1, =0x20001000 // address of node A
    str r1, [r0]





    // bl .
wait_loop:
    wfi
    b wait_loop


    // .section .text
    .align 1 // 2^1
    .type task_a, %function
task_a:
    // toggle PC13
    // GPIOC->ODR |= (1U << 13)  // 0x4001100C
    ldr r0, =0x4001100C
    ldr r1, [r0]
    mov r4, #1
    lsl r4, r4, #13
    eor r1, r1, r4          // R1 = R1 ^ r4
    str r1, [r0]

    bx lr


    // .section .text
    .align 1 // 2^1
    .type task_b, %function
task_b:
    // toggle PA5
    // GPIOC->ODR |= (1U << 5)  // 0x4001100C
    ldr r0, =0x4001080C
    ldr r1, [r0]
    mov r4, #1
    lsl r4, r4, #5
    eor r1, r1, r4          // R1 = R1 ^ r4
    str r1, [r0]    

    bx lr


    // .section .text
    .align 1 // 2^1
    .type systick_handler, %function
systick_handler:
    push {r5, lr}
    add r5, r5, #1


    ldr r0, =0x20001010
    ldr r1, [r0]        // load head pointer (address of node A) into r1            i.e. r1 = 0x20001000
    ldr r1, [r1, #4]    // load next pointer of node A (node B) into r1             i.e. r1 = 0x20001004
    str r1, [r0]        // update head pointer to node B (0x20001008)

    ldr r0, [r0]
    ldr r1, [r0]
    blx r1 // call the function pointed to by the head pointer (initially node A)
    



    // push {r4, r5, r6, r7, r8, r9, r10, r11} // @ Push registers onto the stack



brkp:
    @ bl task_a
    @ bl task_b
    pop {r5, pc}

    bx lr




/** Notes:
 *  https://www.youtube.com/watch?v=socXAnsMSmM&list=PLTbERlX_4R01fR_F1giTebJuAUwEd9IsM&index=16
 *  x/4 0x20001000 - 12 // to print the stack
 *  ni ni ni
 *  break break_here
 * c
 */
// comment