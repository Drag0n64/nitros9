# Dragon 64 + i-MMU-nity Build Recipe

NitrOS-9 Level 2 for a Dragon 64 fitted with an i-MMU-nity MMU board, booting from a
DragonDOS floppy. It is the CoCo 2 i-MMU-nity port (`PORT = immunity`) built with
`-Dd64=1`: the same kernel, MMU layout, CoVDG console (32x16, `/V1`-`/V7`) and VSYNC
clock, plus the Dragon keyboard, the DragonDOS disk controller and a DragonDOS boot loader.

For a stock 32K Dragon 32 see [`../dragon32`](../dragon32/README.md).

## What differs from the CoCo 2 build

| Area | CoCo 2 | Dragon 64 |
|---|---|---|
| Disk driver | `rb1773` | `ddisk` (WD2797 at `$FF40`, drive latch `$FF48`, NMI) |
| Booter | `boot_1773` | `boot_d64` (padded to `$1D0`) |
| Boot loader | Disk BASIC `DOS` loads track 34 | DragonDOS `BOOT` loads `stage0_d64` from LSN 2-17; stage 0 loads track 34 |
| Keyboard | CoCo matrix | Dragon rows converted to CoCo order (`DragonToCoCo` in VTIO) |
| Clock | 60 Hz default | 50 Hz default |
| Disk format | CoCo | Dragon (`os9 format -dr`) |

The Level 2 kernel track (REL `$130` + boot `$1D0` + krn `$F00` = `$1200` bytes) does not
fit the `$1000`-byte DragonDOS boot area, hence the stage-0 loader. REL, krn and the rest
of the kernel track are laid out as on the CoCo.

## Source changes

| File | Change |
|---|---|
| `recipes/immunity/immunity.mak` | `MEDIA=dragon` branch, Dragon descriptors, stage-0 image step, Dragon `run` target |
| `recipes/immunity/dragon/` | this recipe |
| `defs/dragondisk.d` | Dragon disk/PIA/ACIA equates for Level 2 (`dragon.d` clashes with `coco.d`) |
| `level2/immunity/modules/stage0_d64.asm` | DragonDOS boot-area loader (raw binary) |
| `level2/immunity/modules/rel.asm` | `IFNE d64`: HSYNC IRQ off; failure path writes `$FF48` |
| `level2/coco3/modules/vtio.asm` | `IFNE d64`: `DragonToCoCo` after each PIA0 row read |
| `level1/d64/modules/ddisk.asm` | Level 2: `D.MotOn`, `D.NMI`, DP=`$FF` in the NMI handler, `SS.WTrk` refused |
| `level1/d64/modules/boot_d64.asm` | Level 2: `D.NMI`, DP=`$FF` in the NMI handler, `$1D0` padding |

All Dragon code is behind `IFNE d64` or `ifgt Level-1`, so the CoCo floppy and SDC builds
are byte-identical to before (apart from the build date in `sysgo_dd`).

## Build

Requires GNU make, [lwtools](http://www.lwtools.ca) (`lwasm`, `lwlink`, `lwar`) and
[ToolShed](https://github.com/nitros9project/toolshed) (`os9`) on the PATH.

    export NITROS9DIR=/path/to/nitros9
    make -C $NITROS9DIR/recipes/immunity/dragon
    make -C $NITROS9DIR/recipes/immunity/dragon clean      # after changing an option

| Option | Default | Meaning |
|---|---|---|
| `TRACKS=40\|80` | 40 | Double-sided 40 or 80 track disk and descriptors |
| `PwrLnFrq=50\|60` | 50 | Clock rate (PAL 50, NTSC/Tano 60) |
| `VDG_WINDOWS=n` | 7 | Number of `/V` windows, as on the CoCo |

Output in `recipes/immunity/dragon/`:

| File | Content |
|---|---|
| `l2_immunity_dragon.dsk` | Bootable disk image |
| `kerneltrack` | REL + boot_d64 + krn, exactly `$1200` bytes |
| `bootfile` | OS9Boot |
| `.mods/` | Assembled modules |

## Disk image layout

`make` builds the image. The steps it runs:

    os9 format -e -t40 -ds -dd -dr -q l2_immunity_dragon.dsk -n"..."    # Dragon disk
    os9 gen l2_immunity_dragon.dsk -d -t=.mods/stage0_d64               # LSN 2 (boot area)
    os9 gen l2_immunity_dragon.dsk -b=bootfile -t=kerneltrack           # OS9Boot + track 34

| Location | Byte offset | Content |
|---|---|---|
| LSN 2-17 (DragonDOS boot area) | `$200` | `stage0_d64`, starts with `OS` |
| LSN 1224 (cylinder 34, side 0) | `$4C800` | Kernel track, starts with `OS` |

Check an image:

    od -A x -t x1 -j 512    -N 2 l2_immunity_dragon.dsk      # 4f 53
    od -A x -t x1 -j 313344 -N 2 l2_immunity_dragon.dsk      # 4f 53
    os9 dcheck l2_immunity_dragon.dsk                        # "file structure is intact"

## Boot

XRoar:

    xroar -machine dragon64 -machine-opt immunity -cart dragondos \
          -load-fd0 l2_immunity_dragon.dsk -type 'BOOT\r'

In the GUI: machine Dragon 64, i-MMU-nity on, DragonDOS cartridge, image in drive 1, then
type `BOOT`. On a real Dragon 64 with a CoCoSDC: copy the image to the card, `SDRIVE 0,"<name>"`,
then `BOOT`.

On screen: stage 0 changes the top-left character once per sector (18 sectors); REL then
shows the NitrOS-9 boot screen (`0` when LSN0 is read, `.` per bootfile sector); then the
banner, the startup text and Shell+.

## Keyboard

As on the CoCo 2 i-MMU-nity build (same VTIO): CLEAR = next window, SHIFT-CLEAR = previous
window, SHIFT-BREAK = interrupt (`$03`). There is no CTRL, ALT or F1/F2 key.

## Known limitations

- Boots from drive 0 only.
- `format` does not work under Level 2 (`SS.WTrk` returns an error); create disks with
  ToolShed (`os9 format -dr`).
- Stage 0 has no timeout: a missing or unreadable track 34 hangs (the top-left character
  stops, or keeps changing).
- Reboot / crash exit to Dragon BASIC is minimally tested; `reboot -r/-l/-k` are untested.
- The banner reads "Dragon 64 (UK)", from `init.asm`.
- 32x16 CoVDG console only; CoHR / Co42 hi-res text is not part of this port.
