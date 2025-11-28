MAKEFLAGS = -sR
MKDIR = mkdir
RMDIR = rmdir
CP = cp
CD = cd
DD = dd
RM = rm

ASM		= nasm
RUSTC		= rustc
LD		= ld
OBJCOPY		= objcopy
CARGO		= cargo

ASMBFLAGS	= -f elf64 -w-orphan-labels
RUSTFLAGS	= -C target-feature=+crt-static -C relocation-model=static -C link-arg=-nostartfiles
LDFLAGS		= -n -static -T linker.ld -Map HelloOS_Rust.map
OJCYFLAGS	= -S -O binary

HELLOOS_OBJS :=
HELLOOS_OBJS += src/entry.o
HELLOOS_ELF = HelloOS_Rust.elf
HELLOOS_BIN = HelloOS_Rust.bin

.PHONY : build clean all link bin rust-build

all: clean rust-build link bin

clean:
	$(RM) -f *.o *.bin *.elf *.map
	$(CARGO) clean

rust-build:
	$(CARGO) build --release --target x86_64-unknown-none
	$(CP) target/x86_64-unknown-none/release/libhello_os_rust.a libhello_os_rust.a

link: $(HELLOOS_ELF)
$(HELLOOS_ELF): $(HELLOOS_OBJS) libhello_os_rust.a
	$(LD) $(LDFLAGS) -o $@ $(HELLOOS_OBJS) -L. -lhello_os_rust

bin: $(HELLOOS_BIN)
$(HELLOOS_BIN): $(HELLOOS_ELF)
	$(OBJCOPY) $(OJCYFLAGS) $< $@

%.o : %.asm
	$(ASM) $(ASMBFLAGS) -o $@ $<

# 创建目标目录
target-dir:
	$(MKDIR) -p target/x86_64-unknown-none/release

# 安装目标
install: all
	$(DD) if=$(HELLOOS_BIN) of=/dev/sdb bs=512 count=2880 conv=notrunc