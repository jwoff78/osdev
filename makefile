CC = i386-elf-gcc
LD = i386-elf-ld
AS = i386-elf-as
CFLAGS = -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector \
 		 -nostartfiles -nodefaultlibs -Wall -Wextra -Werror \
		 -Isrc -g -Og
ASFLAGS = -march=i486

SRCPATH = src
OBJPATH = obj
TARPATH = bin
TMPPATH = tmp
GRUBPATH = bin/boot/grub

LDSCRIPT = $(SRCPATH)/link.ld
LDFLAGS = -T $(LDSCRIPT) -melf_i386

ISO = grub-mkrescue
ISOFLAGS =
GRUB = grub.cfg
GRUBFILE = $(patsubst %, $(GRUBPATH)/%, $(GRUB))

LIB = io/port io/serial io/device io/framebuffer io/pci io/ata \
	  mm/segment mm/kmem \
	  irq/interrupt irq/pic irq/rtc \
	  fs/vnode fs/dentry fs/superblock fs/fs fs/file \
	  fs/rootfs/rootfs fs/ramfs/ramfs fs/devfs/devfs \
	  util/string util/log util/list
OBJ = loader kmain mm/segment_s irq/interrupt_s mm/page_s \
 	  $(LIB)
LIBFILE = $(patsubst %, $(OBJPATH)/%.o, $(LIB))
LIBHEADER = $(patsubst %, $(SRCPATH)/%.h, $(LIB))
OBJFILE = $(patsubst %, $(OBJPATH)/%.o, $(OBJ))
TARGET = $(TARPATH)/kernel
IMAGE = os.iso

BOCHS = bochs
BOCHSRC = .bochsrc
BOCHSFLAGS = -f $(BOCHSRC) -q

QEMU = qemu-system-i386
QEMULOG = tmp/qemu.log
QEMUSERIAL = tmp/com1.log
QEMUFLAGS = -D $(QEMULOG) -serial file:$(QEMUSERIAL) -s -S \
			-drive file=tmp/hdd.vmdk,if=ide,index=0,media=disk,format=vmdk \
 			-drive file=$(IMAGE),if=ide,index=1,media=cdrom

GDB = i386-elf-gdb

all : $(IMAGE)

run : all
	$(GDB)

qemu: all $(TMPPATH)
	$(QEMU) $(QEMUFLAGS) &

rebuild : clean all

clean :
	rm -fr $(IMAGE) $(TARGET) $(OBJPATH)/*

$(TMPPATH) :
	mkdir -p $@

$(IMAGE) : $(TARGET) $(GRUBFILE) makefile
	$(ISO) $(ISOFLAGS) -o $(IMAGE) $(TARPATH)

$(TARGET) : $(OBJFILE) $(LDSCRIPT) makefile
	mkdir -p $(dir $@)
	$(LD) $(LDFLAGS) -o $@ $(OBJFILE)

$(GRUBPATH)/% : $(SRCPATH)/% makefile
	mkdir -p $(dir $@)
	cp $< $@

$(OBJPATH)/%.o : $(SRCPATH)/%.s makefile
	mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -o $@ $<

$(OBJPATH)/%.o : $(SRCPATH)/%.c makefile
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJPATH)/kmain.o : $(LIBHEADER)

$(LIBFILE) : $(OBJPATH)/%.o : $(SRCPATH)/%.h

.PHONY : all clean rebuild
