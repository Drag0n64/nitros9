# Build all Dragon 64 + i-MMU-nity Level 2 video variants.
# Each subdirectory has independent .obj/.lib/.mods outputs so conditional
# assembler flags cannot leak between variants.

VARIANTS = covdg cohr co42 cocovga

.PHONY: all clean

all:
	@set -e; for variant in $(VARIANTS); do \
		echo "=== Building Dragon Level 2: $$variant ==="; \
		$(MAKE) -C $$variant; \
	done

clean:
	@set -e; for variant in $(VARIANTS); do \
		$(MAKE) -C $$variant clean; \
	done
