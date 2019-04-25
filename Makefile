NAME := kernel.bin
TARGET_PATH = rom/boot/
TARGET = $(TARGET_PATH)$(NAME)
CC := rustc
ASM := nasm
ASM_FLAGS := -f elf32
CFLAGS := --emit=obj,dep-info				\
	-Copt-level=3					\
	--target=i686-unknown-linux-gnu \
	--crate-type lib 
SRC_FILES = test.rs		\
		loader.s		\
		module.rs
SRC_PATH = src/
OPATH = obj/
OFILES = $(addsuffix .o, $(SRC_FILES))
OFILES_O = $(OFILES:.rs.o=.o)
OBJ = $(addprefix $(OPATH), $(OFILES))
OBJ_O = $(addprefix $(OPATH), $(OFILES_O))
LINKER := ld
LINKER_CONF := linker.ld
LINKER_FLAGS := -m elf_i386 --nmagic -T $(LINKER_CONF)

all: $(TARGET) iso

$(TARGET): $(OPATH) $(OBJ)
	$(LINKER) $(LINKER_FLAGS) $(OBJ_O) -o $(TARGET)

$(OPATH):
	mkdir -p $(OPATH)

$(OPATH)%.rs.o: $(SRC_PATH)%.rs
	$(CC) $(CFLAGS) --out-dir $(OPATH) $<

$(OPATH)%.s.o: $(SRC_PATH)%.s
	$(ASM) $(ASM_FLAGS) -o $@ $<

iso:
	grub2-mkrescue -o os.iso rom

clean:
	rm -f $(OBJ_O)

fclean: clean
	rm -f $(TARGET)
	rm -f os.iso

re: fclean all # redo
 
run:
	qemu-system-i386 -cdrom os.iso 

