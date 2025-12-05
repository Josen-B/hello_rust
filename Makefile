# Rust版本Makefile

MAKEFLAGS = -sR
MKDIR = mkdir
RMDIR = rmdir
CP = cp
CD = cd
DD = dd
RM = rm

ASM	= nasm
RUSTC = rustc
LD = ld
OBJCOPY	= objcopy

ASMBFLAGS = -f elf -w-orphan-labels
RUSTFLAGS = -C opt-level=s -C panic=abort --target i686-unknown-linux-gnu -C relocation-model=static -C link-arg=-nostdlib -C link-arg=-nostartfiles -C force-unwind-tables=no -C link-arg=-Wl,--gc-sections
LDFLAGS	= -s -static -T hello_rust.lds -n -Map HelloOS_Rust.map 
OJCYFLAGS = -S -O binary

HELLOOS_OBJS :=
HELLOOS_OBJS += entry.o main.o
HELLOOS_ELF = HelloOS_Rust.elf
HELLOOS_BIN = HelloOS_Rust.bin

.PHONY : build clean all link bin

all: clean build link bin

clean:
	$(RM) -rf *.o *.bin *.elf *.map target

build: $(HELLOOS_OBJS)

link: $(HELLOOS_ELF)
$(HELLOOS_ELF): $(HELLOOS_OBJS)
	$(LD) $(LDFLAGS) -o $@ $(HELLOOS_OBJS)
bin: $(HELLOOS_BIN)
$(HELLOOS_BIN): $(HELLOOS_ELF)
	$(OBJCOPY) $(OJCYFLAGS) $< $@

%.o : %.asm
	$(ASM) $(ASMBFLAGS) -o $@ $<
main.o: src/main.rs src/vga.rs
	$(RUSTC) $(RUSTFLAGS) --emit=obj -o $@ src/main.rs