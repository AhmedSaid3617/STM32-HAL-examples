MEMORY
{
    flash(RX) : o = 0x08000000, l = 128K
    sram(RWX) : o = 0x20000000, l = 20K
}

SECTIONS

{
    .text : {
        *(.vectors*)
        *(.text*)
        *(.rodata)
        _E_text = .;
    } > flash

    .data : {
        _S_DATA = .;
        *(.data)
        . = ALIGN(4);
        _E_DATA = .;
    }> sram AT> flash

    .bss : {
        _S_bss = .;
        *(.bss*)
        _E_bss = .;
    } > sram
}