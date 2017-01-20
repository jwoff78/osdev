# OS Dev #

Learning OS development

## How to build ##

Since I use both x86-64 Mac OS X as host os & GRUB to boot kernel, so I use cross gcc & binutils (for elf32-i386)

So change toolchain in `makefile` if needed

`mkisofs` (which is available on Mac) is used as the tool to generate iso files

Just `make all` to build the final `os.iso`

## Running ##

~~`bochs` is used as a x86 simulator and debugger, a default `.bochsrc` is provided~~

Switch to `qemu` to enable debugging with `gdb`

A `.gdbinit` is provided to configure & link `gdb` with `qemu`

The boot loader is GRUB 0.97, using `stage2_eltorito` for ISO

Both the GRUB binary and `menu.lst` are provided

~~Use `make run` to start the simulator if `bochs` is installed~~

Use `make qemu` to start the simulator __in background__

Use `make run` to start both the simulator and `gdb`, which the simulator will then stop at BIOS boot loader

In `gdb`, customer function `re` is defined to restart the simulator when __it is killed__

Annoyingly, `Ctrl-C` (Signal 2) will kill the background simulator in `gdb` and a solution has not been found on OS X

## Progress ##

### Framework ###

- [x] Bare Bones
- [x] Higher Address Kernel
- [x] Switch to `qemu` & `gdb`
- [x] `multiboot` Info
- [ ] ELF Loader

### Memory ###

- [x] Segmentation
- [x] Kernel Object Manager
- [ ] Frame Allocator
- [ ] User Mode Paging

### IO ###

- [x] Debug Device COM1
- [x] Generic Device Manager
- [x] Framebuffer
- [ ] ATA/ATAPI Disk
- [ ] Filesystem ISO9660

### Interrupt Requests ###

- [x] Interrupt

## Author ##

Tiny

## License ##

MIT

## Reference ##

- [《x86汇编语言：从实模式到保护模式》](https://www.amazon.cn/dp/B00AR0ZSVO/)
- [『30日でできる! OS自作入門』](https://www.amazon.co.jp/dp/4839919844)
- [The little book about OS development](https://littleosbook.github.io/)
- [OSDev.org](http://www.osdev.org/)
