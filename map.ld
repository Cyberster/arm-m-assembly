/* MEMORY
{
    MEM : ORIGIN = 0x0, LENGTH = 0x4000
}

SECTIONS
{
    .text : {
        *(.vectors*)
        *(.text*)
    } > MEM
} */

/* Claud stm32f100
MEMORY
{
    FLASH : ORIGIN = 0x08000000, LENGTH = 128K
    RAM   : ORIGIN = 0x20000000, LENGTH = 8K
}

SECTIONS
{
    .text : {
        *(.vectors*)
        *(.text*)
    } > FLASH
} */

/* Claud stm32f103 bluepill stm32f103c8t6 */
MEMORY
{
    FLASH : ORIGIN = 0x08000000, LENGTH = 64K
    RAM   : ORIGIN = 0x20000000, LENGTH = 20K
}

SECTIONS
{
    .text : {
        *(.vectors*)
        *(.text*)
    } > FLASH
}

/* MEMORY
{
    /* Change 0x0 to 0x08000000 * /
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 128K
    RAM  (rwx) : ORIGIN = 0x20000000, LENGTH = 20K
}

SECTIONS
{
    .text : {
        KEEP(*(.vectors)) /* Ensure vectors aren't optimized away * /
        *(.text*)
        *(.rodata*)
    } > FLASH
} */