# Dragon 64 + i-MMU-nity, normal DragonDOS floppy boot with CoCoSDC as
# an additional RBF hard disk (/SD0 and /SD1). /DD remains DragonDOS.
MEDIA = dragon
RECIPE = immunity_dragon_dos_sdc
PwrLnFrq ?= 50
TRACKS ?= 40
# CoCoSDC supplies the DragonDOS /DD floppy interface as well as the RBF
# hard disk. Keep its DOS floppy emulation enabled after llcocosdc initializes.
AFLAGS_EXTRA += -DKEEPFDC=1
# Preserve the standard DragonDOS floppy and add the CoCoSDC super-driver.
# Do not include ddsd0_cocosdc.dd: that would claim /DD, which must remain
# the DragonDOS boot volume in this recipe.
RBF = rbf.mn ddisk.dr ddd0_dg$(TRACKS).dd d0_dg$(TRACKS).dd \
      d1_dg$(TRACKS).dd d2_dg$(TRACKS).dd \
      rbsuper.dr llcocosdc.dr sd0_cocosdc.dd sd1_cocosdc.dd
STARTUP = $(CURDIR)/startup
include ../immunity.mak
