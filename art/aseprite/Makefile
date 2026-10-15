ASEPRITE ?= aseprite
BIN_DIR  ?= bin

# For setting on an individual basis
ASEFLAGS ?=
# E.g.
# $(BIN_DIR)/player.bmp: ASEFLAGS = --scale 2

SPRITES := $(wildcard *.aseprite)
BITMAPS := $(patsubst %.aseprite,$(BIN_DIR)/%.bmp,$(SPRITES))

# Where bitmaps get copied to
GODOT_SPRITES_DIR ?= ../../app/assets/sprites
GODOT_BITMAPS := $(patsubst $(BIN_DIR)/%.bmp,$(GODOT_SPRITES_DIR)/%.bmp,$(BITMAPS))

all: $(BITMAPS)

.PHONY: install
install: $(GODOT_BITMAPS)

# Copy a single bitmap from BIN_DIR into the Godot project
$(GODOT_SPRITES_DIR)/%.bmp: $(BIN_DIR)/%.bmp | $(GODOT_SPRITES_DIR)
	cp $< $@

$(GODOT_SPRITES_DIR):
	mkdir -p $@

# Convert any .aseprite file into BIN_DIR/<same name>.bmp
$(BIN_DIR)/%.bmp: %.aseprite | $(BIN_DIR)
	$(ASEPRITE) -b $(ASEFLAGS) $< --save-as $@

# Make sure the output directory exists
$(BIN_DIR):
	mkdir -p $@