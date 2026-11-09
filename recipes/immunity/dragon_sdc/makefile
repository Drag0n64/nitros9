# Dragon 64 + i-MMU-nity, Level 2, booting from an 8 MiB CoCoSDC RBF image.
# Start with DragonDOS BOOT; stage0_d64 loads the kernel track, then boot_sdc
# loads OS9Boot and the rest of the system through the CoCoSDC LBA interface.
MEDIA = dragon_sdc
RECIPE = immunity_dragon_sdc
PwrLnFrq ?= 50
STARTUP = $(CURDIR)/startup
include ../immunity.mak
