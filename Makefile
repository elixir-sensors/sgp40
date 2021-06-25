# Makefile for building the Sensirion VOC Algorithm port executable
#
# Variables to override
#
# CC            C compiler
# CROSSCOMPILE  crosscompiler prefix, if any
# CFLAGS        compiler flags for compiling all C files
# LDFLAGS       linker flags for linking all binaries

# Initialize some variables if not set
LDFLAGS ?=
CFLAGS ?= -O2 -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -Wno-parentheses-equality
CC ?= $(CROSSCOMPILE)-gcc

CFLAGS += -std=gnu99

ifeq ($(MIX_COMPILE_PATH),)
  $(error MIX_COMPILE_PATH should be set by elixir_make!)
endif

PREFIX = $(MIX_COMPILE_PATH)/../priv
BUILD  = $(MIX_COMPILE_PATH)/../obj

ifeq ($(CROSSCOMPILE),)
# Host testing build
CFLAGS += -DDEBUG
else
# Normal build
endif

SRC = src/main.c \
      src/sensirion_voc_algorithm.c
OBJ = $(patsubst src/%,$(BUILD)/%,$(SRC:.c=.o))

calling_from_make:

	mix compile

all: $(PREFIX) $(PREFIX)/sgp40

$(PREFIX):
	mkdir -p $@

$(BUILD):
	mkdir -p $@

$(BUILD)/sensirion_voc_algorithm:
	mkdir -p $@

$(BUILD)/%.o: src/%.c $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(PREFIX)/sgp40: $(OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

ifeq ($(CROSSCOMPILE),)
	$(warning No cross-compiler detected. Building native code in test mode.)
	$(warning If you were intending to build in normal mode e.g. directly on a Raspberry Pi,)
	$(warning you can force it by running `CROSS_COMPILE=true mix compile`)
endif

clean:
	rm -rf $(PREFIX)/* $(BUILD)/*

.PHONY: all clean calling_from_make
