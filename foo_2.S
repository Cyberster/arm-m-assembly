.section .vectors
vector_table:
    .word 0x20001000
    .word reset_handler
    .zero 400

    .section .text
    .align 1
    .type reset_handler, %function
reset_handler:
    mov r1, #1
    mov r2, #2
    mov r3, #3

    push {r1, r2, r3}
    // LDR SP, 0x20001000 // experimental

    // mov r1, #0xFF
    // mov r2, #0xFF
    // mov r3, #0xFF
    movw r1, #0xDEAD
    movw r2, #0xDEAD
    movw r3, #0xDEAD

    pop {r3, r2, r1}

    bl .

/** Notes:
 *  https://www.youtube.com/watch?v=KIcxcn--OiU&list=PLTbERlX_4R01fR_F1giTebJuAUwEd9IsM&index=11
 *  x/4 0x20001000 - 12 // to print the stack
 */
// comment