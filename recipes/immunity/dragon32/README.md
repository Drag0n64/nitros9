# Dragon 32 (non-upgraded) + i-MMU-nity Build Recipe

NitrOS-9 Level 2 for a stock Dragon 32 with 32K motherboard RAM and an i-MMU-nity
board, booting from a DragonDOS floppy. It is the Dragon 64 recipe (`../dragon`) built
with `-Dd32=1 -DUpgraded32=1`.

**Rule: the motherboard RAM above `$7FFF` is never read or written.** Everything the OS
needs there comes from i-MMU-nity board RAM. Only motherboard `$0000-$7FFF` (MMU blocks
`$38-$3B`) is used: the boot and text screens (block `$3B`) and up to three 8K graphics screens.

## Build

    export NITROS9DIR=~/nitros9-immunity
    make -C $NITROS9DIR/recipes/immunity/dragon32          # l2_immunity_dragon32.dsk
    make -C $NITROS9DIR/recipes/immunity/dragon32 clean

Options as for the Dragon 64: `TRACKS=40|80`, `PwrLnFrq=50|60` (default 50), `VDG_WINDOWS=n`.
The image layout and boot sequence (stage-0 loader in the DragonDOS boot area, kernel
track on track 34) are the same as `../dragon`.

## Run in XRoar (32K machine)

A profile with `machine-arch dragon32`, `ram 32`, `machine-opt immunity` and DragonDOS:

    xroar -default-machine dragon32imm -load-fd0 l2_immunity_dragon32.dsk -type "BOOT\r"

## What differs from the Dragon 64 build

| Area | Dragon 64 | Dragon 32 | Why |
|---|---|---|---|
| Kernel block (`KrnBlk`, in slot 7 of the system map) | `$3F` (motherboard `$E000-$FFFF`) | `$37`, board RAM | `$3F` is backed only at its top 512 bytes on a 32K machine |
| MC3 and the `$FExx` page | on, block `$3F` | on, same bit (XRoar backs the page with RAM on 32K) | same |
| SAM map type | map type 1 (`clr $FFDF`) | stays map type 0 | no motherboard RAM above `$7FFF` |
| Block map | `$38-$3E` reserved | `$38-$3F` reserved, kernel block flagged `NotRAM+RAMinUse` | `$3F` is no longer the kernel |
| CoVDG graphics pool | `$38-$3D` except `$3B` | `$38-$3A` | `$3C-$3E` do not exist on 32K |
| `reboot` reload scratch block | `$3F` | `KrnBlk` | follows the kernel block |
| 6551 ACIA | used by ddisk and stage 0 | none (`Upgraded32`) | `$FF04-$FF07` alias onto PIA0 |
| Banner | Dragon 64 (UK) | Dragon 32 + i-MMU-nity | |

Everything else (ddisk, boot_d64, keyboard, clock, VDG windows) is shared with the Dragon 64.

## Limits

- A process gets `$0000-$FDFF` (63.5K); its data area is at most 56K (`dir #56K` works, `#57K` gives error 207). Same as the Dragon 64.
- Needs an i-MMU-nity with at least 512K (kernel in block `$37`).
- Verified only in XRoar's iMMUnity model. On real hardware the board must (1) override the
  ROM/cartridge area `$8000-$FEFF` in SAM map type 0, (2) provide RAM for the MC3 page
  (`$FE00-$FEFF`, block `$3F` offset `$1E00`) and (3) provide the alternate vector page, all
  with only 32K on the motherboard. Confirm these with the board designer.
- `reboot -r/-l/-k` (reload paths) are untested; plain `reboot` returns to Dragon BASIC.
- Level 2 disk format (`SS.WTrk`) is not supported; make disks with ToolShed (`os9 format -dr`).
