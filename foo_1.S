.section .vectors
vector_table:
    .word 0xABC0
    .word reset_handler
    .zero 400

    .section .text
    .align 1
    .type reset_handler, %function
reset_handler:
    mov r1, #7
    mov r2, #3
    add r3, r1, r2

    b label_a

label_b:
    sub r4, r1, r2
    b label_end

label_a:
    mov r5, r3
    lsl r6, r5, #2
    b label_b

label_end:
    bl .

/* assembly file
    labels
    directives
    comments
    instructions
 */
// comment