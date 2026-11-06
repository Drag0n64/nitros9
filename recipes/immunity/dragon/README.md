# Dragon 64 + i-MMU-nity Level 2 recipes

This directory builds four bootable DragonDOS floppy images from the shared
Level 2 i-MMU-nity build logic. Run from the NitrOS-9 repository root:

```sh
make -C recipes/immunity/dragon
```

The variants are isolated in separate directories:

| Directory | Video console | Resolution | Output image |
| --- | --- | ---: | --- |
| `covdg/` | Standard VDG | 32x16 | `l2_dragon_covdg.dsk` |
| `cohr/` | CoHR | 51x24 | `l2_dragon_cohr.dsk` |
| `co42/` | Co42 | 42x24 | `l2_dragon_co42.dsk` |
| `cocovga/` | CoCoVGA | 64x32 | `l2_dragon_cocovga.dsk` |

Build one variant by invoking make in its directory, for example:

```sh
make -C recipes/immunity/dragon/cocovga
```

Each variant uses the DragonDOS boot path from the parent Dragon recipe,
including `boot_d64`, `stage0_d64`, the Dragon disk descriptors, and the
shared startup file. Build products stay in the corresponding variant
directory. The common definitions file is in this directory's parent recipe
directory and is added to the assembler include path.

CoCoVGA uses four contiguous 512-byte page pairs (2K) per text screen. The
available i-MMU-nity motherboard text-screen area therefore supports
`/term`, `/V1`, and `/V2`; the CoCoVGA build defaults to two extra screens.
