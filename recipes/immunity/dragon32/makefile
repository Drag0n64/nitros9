# Dragon 32 (non-upgraded, 32K motherboard RAM) + i-MMU-nity, Level 2,
# booting from a DragonDOS floppy (TRACKS=40|80).
#
# Same recipe as ../dragon (Dragon 64) with:
#   -Dd32=1         no motherboard RAM above $7FFF is ever used: the kernel
#                   block (KrnBlk) is board RAM, MC3 pins only the $FExx page (as on a
#                   CoCo 3), SAM stays in map type 0, motherboard blocks $38-$3F
#                   are reserved
#   -DUpgraded32=1  no 6551 ACIA on a Dragon 32 (ddisk and stage 0 must not
#                   touch $FF04-$FF07: the address decoding aliases them onto PIA0)
MEDIA = dragon
RECIPE = immunity_dragon32
AFLAGS_EXTRA += -Dd32=1 -DUpgraded32=1
PwrLnFrq ?= 50
STARTUP = $(CURDIR)/startup
include ../immunity.mak
