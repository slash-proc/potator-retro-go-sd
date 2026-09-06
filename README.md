# Watara Supervision (Potator) — Retro-Go SD dynamic core

Standalone [Potator](https://github.com/libretro/potator) port for
[Game & Watch Retro-Go SD](https://github.com/sylverb/game-and-watch-retro-go-sd).

Produces `potator.bin` → `/cores/potator.bin`. ROMs under `/roms/wsv/`
(`.wsv`, `.sv`, `.bin`).

## Memory layout

| Region | Use |
|--------|-----|
| **ITCM** | Hot `.text`: m6502, memorymap, watara, gpu, sound, timer, controls |
| **DTCM** | Emulator WRAM / regs (`dtc_malloc`, 3×8 KiB — formerly `itc_malloc`) |
| **RAM_EMU** | Core image, framebuffer BSS, cart ROM via `ram_malloc` |
| **AHB** | Optional ghosting buffers only (`malloc`) |

ITCM is **code only** — no heap data.

## Build

```bash
make                  # → potator.bin
make host             # → potator_host (SDL2)
make host HOST_SDL=3
make docker
```

```bash
./potator_host /path/to/game.sv
```

Controls: arrows = D-pad, `Z`/`X` = B/A, Enter = Start, Shift = Select,
`A`/`S` = Y/X. `F1`/`F2` = save/load state under `./host_saves/`.

Pack logos use inverted BMP icons (`--logo-invert`).
