ENTRY(_start)
OUTPUT_ARCH(i386:x86-64)
OUTPUT_FORMAT(elf64-x86-64)

SECTIONS
{
    . = 0x200000;
    
    __begin_start_text = .;
    .start.text : ALIGN(8) { 
        *(.start.text) 
    }
    __end_start_text = .;

    __begin_text = .;
    .text : ALIGN(8) { 
        *(.text) 
    }
    __end_text = .;

    __begin_rodata = .;
    .rodata : ALIGN(8) { 
        *(.rodata) 
        *(.rodata.*) 
    }
    __end_rodata = .;

    __begin_data = .;
    .data : ALIGN(8) { 
        *(.data) 
    }
    __end_data = .;

    __begin_bss = .;
    .bss : ALIGN(8) { 
        *(.bss) 
        *(COMMON) 
    }
    __end_bss = .;
    
    /*
     * End of uninitalized data segement
     */
    . = ALIGN(8);
    end = .;
}