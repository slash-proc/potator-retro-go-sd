/*
 * Watara Supervision (Potator) core linker script — RAM_EMU + ITCM hot segment.
 *
 * ITCM holds CPU-hot .text (m6502, memory map, watara exec, GPU scanline,
 * sound, timer, controls). Emulator WRAM that used to live in ITCM via
 * itc_malloc is allocated from DTCM (dtc_malloc) at runtime.
 */

INCLUDE gnw_ram_emu.ld
INCLUDE gnw_itcm_core.ld

MEMORY
{
  RAM_EMU (xrw) : ORIGIN = __RAM_EMU_START__, LENGTH = __RAM_EMU_LENGTH__
  ITCM    (xrw) : ORIGIN = __ITCM_CORE_START__, LENGTH = __ITCM_CORE_LENGTH__
}

/* Object paths match BUILD_DIR=build/core (flat names under that dir). */

SECTIONS
{
  .core_entry __RAM_EMU_START__ :
  {
    KEEP(*(.core_entry))
    KEEP(*(.gw_core_bridge_probe))

    . = ALIGN(4);
    EXCLUDE_FILE(
      build/core/m6502.o
      build/core/memorymap.o
      build/core/watara.o
      build/core/gpu.o
      build/core/wsv_sound.o
      build/core/timer.o
      build/core/controls.o
    ) *(.text*)
    *(.rodata*)
    *(.glue_7)
    *(.glue_7t)

    . = ALIGN(4);
    __CORE_INIT_ARRAY_START__ = .;
    KEEP(*(SORT(.init_array.*)))
    KEEP(*(.init_array*))
    __CORE_INIT_ARRAY_END__ = .;
  } >RAM_EMU

  .data :
  {
    *(.data*)
  } >RAM_EMU

  __CORE_CODE_END__ = .;

  .bss (NOLOAD) :
  {
    . = ALIGN(8);
    *(.bss*)
    *(COMMON)
    . = ALIGN(8);
  } >RAM_EMU

  __CORE_BSS_END__ = .;

  ASSERT(__CORE_BSS_END__ <= __RAM_EMU_END__,
         "Error: Potator RAM_EMU segment (code+data+bss) overflows RAM_EMU")

  .core_itcm __ITCM_CORE_START__ :
  {
    __CORE_ITCM_CODE_START__ = .;
    build/core/m6502.o(.text*)
    build/core/memorymap.o(.text*)
    build/core/watara.o(.text*)
    build/core/gpu.o(.text*)
    build/core/wsv_sound.o(.text*)
    build/core/timer.o(.text*)
    build/core/controls.o(.text*)
    . = ALIGN(4);
    __CORE_ITCM_CODE_END__ = .;
  } >ITCM AT>RAM_EMU

  __CORE_ITCM_BSS_END__ = __CORE_ITCM_CODE_END__;

  ASSERT(__CORE_ITCM_BSS_END__ <= __ITCM_CORE_START__ + __ITCM_CORE_LENGTH__,
         "Error: Potator ITCM segment overflows the 64K ITCM region")

  __exidx_start = .;
  __exidx_end = .;

  /DISCARD/ :
  {
    *(.fini_array*)
    *(.preinit_array*)
    *(.ARM.exidx*)
    *(.ARM.extab*)
    *(.comment)
    *(.ARM.attributes)
  }
}
