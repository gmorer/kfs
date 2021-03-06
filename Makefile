NAME := kernel.bin
TARGET_PATH = rom/boot
TARGET = $(TARGET_PATH)/$(NAME)
MKRESCUE := $(shell which grub2-mkrescue 2>&- && echo grub2-mkrescue || echo grub-mkrescue)
CC := rustc
ASM := nasm
ASM_FLAGS := -f elf32
CFLAGS := \
	--emit=obj,dep-info \
	-Copt-level=3 \
	--target=i686-unknown-linux-gnu \
	-Cpanic=abort \
	--crate-type staticlib 
OBJS = \
	loader.o \
	kmain.o \
	vga_buffer.o
SRC_PATH := src
OBJ_PATH := obj
ALL_OBJS :=$(addprefix $(OBJ_PATH)/, $(OBJS))
LINKER := ld
LINKER_CONF := linker.ld
LINKER_FLAGS := -m elf_i386 --nmagic -T $(LINKER_CONF)

all: iso

$(TARGET): $(ALL_OBJS)
	$(LINKER) $(LINKER_FLAGS) $(ALL_OBJS) -o $(TARGET)

$(OPATH):
	mkdir -p $(OPATH)

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.rs
	[[ -f $(OBJ_PATH) ]] || mkdir -p $(OBJ_PATH)
	$(CC) $(CFLAGS) --out-dir $(OBJ_PATH) $<

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.s
	[[ -f $(OBJ_PATH) ]] || mkdir -p $(OBJ_PATH)
	$(ASM) $(ASM_FLAGS) -o $@ $<

iso: $(TARGET)
	$(MKRESCUE) -o os.iso rom

clean:
	rm -rf $(OBJ_PATH)

fclean: clean
	rm -f $(TARGET)
	rm -f os.iso

re:
	@$(MAKE) fclean
	@$(MAKE) all
 
run:
	qemu-system-i386 -cdrom os.iso 

