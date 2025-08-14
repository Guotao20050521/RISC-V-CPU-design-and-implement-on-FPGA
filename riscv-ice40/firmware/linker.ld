MEMORY {
    RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 4K
}

SECTIONS {
    .text : {
        *(.init)
        *(.text*)
    } > RAM
    
    .rodata : { *(.rodata*) } > RAM
    .data : { *(.data*) } > RAM
    .bss : { *(.bss*) } > RAM
    
    __stack_top = ORIGIN(RAM) + LENGTH(RAM);
}