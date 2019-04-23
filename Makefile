NAME := kernel.bin
TARGET_PATH = rom/boot/
TARGET = $(TARGET_PATH)$(NAME)
CC := gcc
ASM := nasm
ASM_FLAGS := -f elf32
CFLAGS := -m32			\
	-nostdlib		\
	-fno-builtin		\
	-fno-exceptions		\
	-fno-stack-protector	\
	-nodefaultlibs
SRC_FILES = kmain.c	\
		loader.s	\
		vga_buffer.c
SRC_PATH = src/
OPATH = obj/
OFILES = $(addsuffix .o, $(SRC_FILES))
OBJ = $(addprefix $(OPATH), $(OFILES))
HPATH = inc/
HFILES = \
	inc/kfs.h
INC = $(addprefix -I./, $(HPATH))
LINKER := ld
LINKER_CONF := linker.ld
LINKER_FLAGS := -m elf_i386 --nmagic -T $(LINKER_CONF)

all: $(TARGET) iso

$(TARGET): $(OPATH) $(OBJ)
	$(LINKER) $(LINKER_FLAGS) $(OBJ) -o $(TARGET)

$(OPATH):
	mkdir -p $(OPATH)

$(OPATH)%.c.o: $(SRC_PATH)%.c $(HFILES)
	$(CC) $(INC) $(CFLAGS) -c -o $@ $<

$(OPATH)%.s.o: $(SRC_PATH)%.s
	$(ASM) $(ASM_FLAGS) -o $@ $<

iso:
	grub2-mkrescue -o os.iso rom

clean:
	rm -f $(OBJ)

fclean: clean
	rm -f $(TARGET)
	rm -f os.iso

re: fclean all # redo
 
run:
	qemu-system-i386 -cdrom os.iso -curses

