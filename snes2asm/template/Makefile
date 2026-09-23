LLVM_MOS ?= ../llvm-mos
MC=$(LLVM_MOS)/bin/llvm-mc
LD=$(LLVM_MOS)/bin/ld.lld
OBJCOPY=$(LLVM_MOS)/bin/llvm-objcopy
PYTHON ?= python3
BMP2CHR=bmp2chr
PACKER=packer
BRR=brr
ROM=game
COBJ=game.o
LELF=game.elf
EMPTYFILL=%empty_fill
CHECKSUM_OFFSET=%checksum_offset
MCFLAGS=--arch=mos --mcpu=mosw65816
SPCFLAGS=--arch=mos --mcpu=mosspc700

all: check-llvm graphics sound spc700 encodings $(ROM).smc
	echo "Done"

# Check if the llvm-mos binaries are available
.PHONY: check-llvm
check-llvm:
	@command -v $(MC) >/dev/null 2>&1 || { \
		echo ""; \
		echo "ERROR: $(MC) not found!"; \
		echo ""; \
		echo "Please install the llvm-mos toolchain:"; \
		echo "  https://llvm-mos.org"; \
		echo ""; \
		exit 1; \
	}
	@command -v $(LD) >/dev/null 2>&1 || { \
		echo ""; \
		echo "ERROR: $(LD) not found!"; \
		echo ""; \
		echo "Please install the llvm-mos toolchain:"; \
		echo "  https://llvm-mos.org"; \
		echo ""; \
		exit 1; \
	}
	@command -v $(OBJCOPY) >/dev/null 2>&1 || { \
		echo ""; \
		echo "ERROR: $(OBJCOPY) not found!"; \
		echo ""; \
		echo "Please install the llvm-mos toolchain:"; \
		echo "  https://llvm-mos.org"; \
		echo ""; \
		exit 1; \
	}

.PHONY: graphics
graphics: $(patsubst %.bmp,%.chr,$(wildcard *2bpp.bmp *3bpp.bmp *4bpp.bmp *8bpp.bmp))

%2bpp.chr: %2bpp.bmp
	$(BMP2CHR) -b2 -o $@ $<

%3bpp.chr: %3bpp.bmp
	$(BMP2CHR) -b3 -o $@ $<

%4bpp.chr: %4bpp.bmp
	$(BMP2CHR) -b4 -o $@ $<

%8bpp.chr: %8bpp.bmp
	$(BMP2CHR) -b8 -o $@ $<

.PHONY: sound
sound: $(patsubst %.wav,%.brr,$(wildcard *.wav))

%.brr: %.wav
	$(BRR) encode -o $@ $<

.PHONY: spc700
spc700: $(patsubst %.S,%.spc,$(wildcard *.S))

# Assemble SPC700 assembly to an object file
%.obj: %.S
	$(MC) $(SPCFLAGS) --filetype=obj -o $@ $<

# Link SPC700 object file to a binary
%.spc: %.obj
	$(LD) --entry=0 --defsym __abs_base=0 -o $*.elf $<
	$(OBJCOPY) -O binary $*.elf $@

.PHONY: encodings
encodings: %encode_files

%endcode_targets

main.s: $(wildcard *.asm)
	touch main.s

$(COBJ): main.s $(wildcard *.asm)
	$(MC) $(MCFLAGS) --filetype=obj -o $@ main.s

$(LELF): $(COBJ) link.ld
	$(LD) --entry=0 -T link.ld -o $@ $(COBJ)

$(ROM).smc: $(LELF)
	$(OBJCOPY) -O binary --gap-fill 0x$(EMPTYFILL) $< $@
	$(PYTHON) snescsum.py $@ $(CHECKSUM_OFFSET)

clean:
	rm -f $(ROM).smc $(COBJ) $(LELF) *.obj *.elf *.spc
