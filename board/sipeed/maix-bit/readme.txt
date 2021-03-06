Sipeed MAIX-Bit Board
=====================

The Sipeed MAXI-Bit board is a dual-core RISC-V 64-bits board based on the
Canaan Kendryte K210 SoC.

Prerequisite
------------

In order to use the kflash utility to program this board, the user must have
access to the board USB serial device file. The simplest way to do this is to
add your user to the same group as this device file. Assume the device file is
/dev/ttyUSB0, first identify the device group name. In most cases, it is
either "dialout" or "uucp". Also verify that read-write access is enabled for
the group:

```
$ ls -l /dev/ttyUSB0
crw-rw---- 1 root dialout 188, 0 May 26 13:48 /dev/ttyUSB0
```

Then add yourself to that group (dialout in this example):

```
$ sudo usermod -a -G dialout $(whoami)
```

To enable the above, it is sometimes necessary to logout and login again.

Buildroot Configuration
-----------------------

Two buildroot configuration files are provided:

(1) Direct Linux Kernel Boot

This is defined by the sipeed_maix_bit_defconfig configuration. This
configuration allows building a bootable kernel image with a built-in initramfs
root file system (the board SD card is not used). The built kernel image can be
flashed directly to the board ROM for direct booting. No boot loader is
required.

(2) U-Boot SD-Card Boot

The sipeed_maix_bit_sdcard_defconfig configuration allows building a kernel
image with the root file system on the board SD card. U-Boot is used as the
boot loader.

Both configuration files will also compile and install the kflash and
pyserial-miniterm host utilities to program bootable image files to the board
and open a serial terminal console.

Direct Linux Kernel Boot
-------------------------

Using the sipeed_maix_bit_defconfig configuration, the bootable kernel binary
image is built as follows.

```
$ make sipeed_maix_bit_defconfig
$ make
```

The bootable binary image is the output/images/loader.bin file. This image file
can be written to the board boot ROM using the kflash utility.

```
$ output/host/bin/kflash -b 1500000 -p /dev/ttyUSB0 -t output/images/loader.bin
```

Once the kernel image file is fully programmed, a terminal console is open and
the board can be rebooted by pressing the reset button on the board (if it does
not reboot automatically).

The output will be similar to the following.

```
[    0.000000] Linux version 5.18.0 (foo@bar.com) (riscv64-buildroot-linux-uclibc-gcc.br_real (Buildroot 2022.02-560-g6a2b542a09-dirty) 10.3.0, GNU ld (GNU Binutils) 2.32) #2 SMP Thu Apr 21 14:30:02 JST 2022
[    0.000000] Machine model: SiPeed MAIX BiT
[    0.000000] earlycon: sifive0 at MMIO 0x0000000038000000 (options '115200n8')
[    0.000000] printk: bootconsole [sifive0] enabled
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x0000000080000000-0x00000000807fffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000080000000-0x00000000807fffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000080000000-0x00000000807fffff]
[    0.000000] riscv: ISA extensions acdfim
[    0.000000] riscv: ELF capabilities acdfim
[    0.000000] percpu: max_distance=0x16000 too large for vmalloc space 0x0
[    0.000000] percpu: Embedded 11 pages/cpu s15264 r0 d29792 u45056
[    0.000000] percpu: wasting 10 pages per chunk
[    0.000000] Built 1 zonelists, mobility grouping off.  Total pages: 2020
[    0.000000] Kernel command line: earlycon console=ttySIF0
[    0.000000] Dentry cache hash table entries: 1024 (order: 1, 8192 bytes, linear)
[    0.000000] Inode-cache hash table entries: 512 (order: 0, 4096 bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 5996K/8192K available (964K kernel code, 137K rwdata, 205K rodata, 530K init, 66K bss, 2196K reserved, 0K cma-reserved)
[    0.000000] rcu: Hierarchical RCU implementation.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
[    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000] riscv-intc: 64 local interrupts mapped
[    0.000000] plic: interrupt-controller@c000000: mapped 65 interrupts with 2 handlers for 4 contexts.
[    0.000000] k210-clk: clock-controller: CPU running at 390 MHz
[    0.000000] clint: timer@2000000: timer running at 7800000 Hz
[    0.000000] clocksource: clint_clocksource: mask: 0xffffffffffffffff max_cycles: 0x3990be68b, max_idle_ns: 881590404272 ns
[    0.000001] sched_clock: 64 bits at 7MHz, resolution 128ns, wraps every 4398046511054ns
[    0.008188] Calibrating delay loop (skipped), value calculated using timer frequency.. 15.60 BogoMIPS (lpj=31200)
[    0.018250] pid_max: default: 4096 minimum: 301
[    0.022860] Mount-cache hash table entries: 512 (order: 0, 4096 bytes, linear)
[    0.029972] Mountpoint-cache hash table entries: 512 (order: 0, 4096 bytes, linear)
[    0.040244] rcu: Hierarchical SRCU implementation.
[    0.045121] smp: Bringing up secondary CPUs ...
[    0.050225] smp: Brought up 1 node, 2 CPUs
[    0.054355] devtmpfs: initialized
[    0.071168] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.080240] pinctrl core: initialized pinctrl subsystem
[    0.119221] clocksource: Switched to clocksource clint_clocksource
[    0.131498] workingset: timestamp_bits=62 max_order=11 bucket_order=0
[    0.176943] k210-sysctl 50440000.syscon: K210 system controller
[    0.193558] k210-rst 50440000.syscon:reset-controller: K210 reset controller
[    0.201526] cacheinfo: Unable to detect cache hierarchy for CPU 0
[    0.211611] i2c_dev: i2c /dev entries driver
[    0.221375] k210-fpioa 502b0000.pinmux: K210 FPIOA pin controller
[    0.233591] 38000000.serial: ttySIF0 at MMIO 0x38000000 (irq = 1, base_baud = 115200) is a SiFive UART v0
[    0.242529] printk: console [ttySIF0] enabled
[    0.242529] printk: console [ttySIF0] enabled
[    0.251165] printk: bootconsole [sifive0] disabled
[    0.251165] printk: bootconsole [sifive0] disabled
[    0.274348] Freeing unused kernel image (initmem) memory: 524K
[    0.279504] This architecture does not have kernel memory protection.
[    0.285908] Run /init as init process
          __  _
         / / (_) ____   _   _ __  __
        / /  | ||  _ \ | | | |\ \/ /
       / /___| || | | || |_| | >  <
      /_____/|_||_| |_| \____|/_/\_\
    64-bits RISC-V Kendryte K210 NOMMU

/ #
```

To open a terminal console without re-flashing the board, the pyserial-miniterm
host tool can be used.

```
$ output/host/bin/pyserial-miniterm --raw --eol=LF /dev/ttyUSB0 115200
```

The options "--raw" and "--eol=LF" are added here to avoid a double carriage
return each time a command is entered.


U-Boot SD-Card Boot
-------------------

The build procedure is similar to the direct Linux kernel boot case.

```
$ make sipeed_maix_bit_sdcard_defconfig
$ make
```

The build process will generate two files under the output/images directory.

* sdcard.img: The image file for the SD card filesystem. This image has 2
  partitions. The first partition is a vfat partition containing the kernel
  uImage and the board device tree binary. The second partition is the root
  filesystem with busybox installed. The second partition is formatted using
  ext2 (rev1).

* uboot.bin: U-Boot bootable binary to load and boot the kernel from the SD
  card.

The SD card can be prepared by writing the sdcard.img file, as follows.

```
$ sudo dd if=output/images/sdcard.img of=/dev/sdX bs=1M
$ sync
$ eject /dev/sdX
```

Where /dev/sdX is the device file name of the SD card. Once completed, the SD
card can be inserted into the board and the U-Boot binary image written to the
board boot flash using the kflash utility.

```
$ output/host/bin/kflash -b 1500000 -p /dev/ttyUSB0 -t output/images/u-boot.bin
```

The above command will program U-Boot image to the board boot ROM and open a
terminal console once the u-boot.bin file is fully programmed. Reboot into the
newly programmed environment by pressing the board reset button.

The output will be similar to the following.

```
U-Boot 2022.04 (May 24 2022 - 17:08:34 +0900)

DRAM:  8 MiB
Core:  34 devices, 17 uclasses, devicetree: separate
WDT:   Not starting watchdog@50400000
MMC:   spi@53000000:slot@0: 0
Loading Environment from SPIFlash... SF: Detected gd25lq128 with page size 256 Bytes, erase size 4 KiB, total 16 MiB
*** Warning - bad CRC, using default environment

In:    serial@38000000
Out:   serial@38000000
Err:   serial@38000000
Hit any key to stop autoboot:  0
1668562 bytes read in 933 ms (1.7 MiB/s)
10468 bytes read in 11 ms (928.7 KiB/s)
## Booting kernel from Legacy Image at 80060000 ...
   Image Name:   Linux
   Image Type:   RISC-V Linux Kernel Image (uncompressed)
   Data Size:    1668498 Bytes = 1.6 MiB
   Load Address: 80000000
   Entry Point:  80000000
   Verifying Checksum ... OK
## Flattened Device Tree blob at 80400000
   Booting using the fdt blob at 0x80400000
   Loading Kernel Image
   Loading Device Tree to 00000000803fa000, end 00000000803ff8e3 ... OK

Starting kernel ...

[    0.000000] Linux version 5.18.0 (foo@bar.com) (riscv64-buildroot-linux-uclibc-gcc.br_real (Buildroot 2022.02-1056-gc356b62332) 10.3.0, GNU ld (GNU Binutils) 2.37) #1 SMP Tue May 24 06:45:04 JST 2022
[    0.000000] Machine model: SiPeed MAIX BiT
[    0.000000] earlycon: sifive0 at MMIO 0x0000000038000000 (options '115200n8')
[    0.000000] printk: bootconsole [sifive0] enabled
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x0000000080000000-0x00000000807fffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000080000000-0x00000000807fffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000080000000-0x00000000807fffff]
[    0.000000] riscv: base ISA extensions acdfim
[    0.000000] riscv: ELF capabilities acdfim
[    0.000000] percpu: max_distance=0x16000 too large for vmalloc space 0x0
[    0.000000] percpu: Embedded 11 pages/cpu s15648 r0 d29408 u45056
[    0.000000] percpu: wasting 10 pages per chunk
[    0.000000] Built 1 zonelists, mobility grouping off.  Total pages: 2020
[    0.000000] Kernel command line: earlycon console=ttySIF0 root=/dev/mmcblk0p2 rootwait ro
[    0.000000] Dentry cache hash table entries: 1024 (order: 1, 8192 bytes, linear)
[    0.000000] Inode-cache hash table entries: 512 (order: 0, 4096 bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 6204K/8192K available (1134K kernel code, 150K rwdata, 239K rodata, 100K init, 68K bss, 1988K reserved, 0K cma-reserved)
[    0.000000] rcu: Hierarchical RCU implementation.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
[    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000] riscv-intc: 64 local interrupts mapped
[    0.000000] plic: interrupt-controller@c000000: mapped 65 interrupts with 2 handlers for 4 contexts.
[    0.000000] k210-clk: clock-controller: CPU running at 390 MHz
[    0.000000] clint: timer@2000000: timer running at 7800000 Hz
[    0.000000] clocksource: clint_clocksource: mask: 0xffffffffffffffff max_cycles: 0x3990be68b, max_idle_ns: 881590404272 ns
[    0.000001] sched_clock: 64 bits at 7MHz, resolution 128ns, wraps every 4398046511054ns
[    0.008194] Calibrating delay loop (skipped), value calculated using timer frequency.. 15.60 BogoMIPS (lpj=31200)
[    0.018257] pid_max: default: 4096 minimum: 301
[    0.022869] Mount-cache hash table entries: 512 (order: 0, 4096 bytes, linear)
[    0.029982] Mountpoint-cache hash table entries: 512 (order: 0, 4096 bytes, linear)
[    0.040424] rcu: Hierarchical SRCU implementation.
[    0.045397] smp: Bringing up secondary CPUs ...
[    0.050518] smp: Brought up 1 node, 2 CPUs
[    0.054676] devtmpfs: initialized
[    0.072365] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.081396] pinctrl core: initialized pinctrl subsystem
[    0.123762] clocksource: Switched to clocksource clint_clocksource
[    0.136796] workingset: timestamp_bits=62 max_order=11 bucket_order=0
[    0.181768] k210-sysctl 50440000.syscon: K210 system controller
[    0.198397] k210-rst 50440000.syscon:reset-controller: K210 reset controller
[    0.207373] cacheinfo: Unable to detect cache hierarchy for CPU 0
[    0.218270] spi spi1.0: setup: ignoring unsupported mode bits a00
[    0.224786] i2c_dev: i2c /dev entries driver
[    0.235984] k210-fpioa 502b0000.pinmux: K210 FPIOA pin controller
[    0.249172] 38000000.serial: ttySIF0 at MMIO 0x38000000 (irq = 1, base_baud = 115200) is a SiFive UART v0
[    0.258078] printk: console [ttySIF0] enabled
[    0.258078] printk: console [ttySIF0] enabled
[    0.266707] printk: bootconsole [sifive0] disabled
[    0.266707] printk: bootconsole [sifive0] disabled
[    0.307910] mmc_spi spi3.0: SD/MMC host mmc0, no WP, no poweroff, cd polling
[    0.319869] Waiting for root device /dev/mmcblk0p2...
[    0.345016] mmc0: host does not support reading read-only switch, assuming write-enable
[    0.352330] mmc0: new SDHC card on SPI
[    0.359338] mmcblk0: mmc0:0000 SA16G 14.5 GiB
[    0.367589] random: fast init done
[    0.371533]  mmcblk0: p1 p2
[    0.391794] random: get_random_bytes called from 0x0000000080095ae8 with crng_init=1
[    0.393388] VFS: Mounted root (ext2 filesystem) readonly on device 179:2.
[    0.411377] devtmpfs: mounted
[    0.413922] Freeing unused kernel image (initmem) memory: 96K
[    0.419344] This architecture does not have kernel memory protection.
[    0.425777] Run /sbin/init as init process
[    0.718314] random: crng init done
[    0.799903] init (1): drop_caches: 3
          __  _
         / / (_) ____   _   _ __  __
        / /  | ||  _ \ | | | |\ \/ /
       / /___| || | | || |_| | >  <
      /_____/|_||_| |_| \____|/_/\_\
    64-bits RISC-V Kendryte K210 NOMMU

/ #
```

Of note is that the kernel mounts the SD card as read-only by default to avoid
corruptions of the ext2 root file system when the board is powered down. This
is recommended as this board does not support clean shutdown or halt.

Similarly to the initramfs build case, a console can be open without
re-flashing the board using the host tool pyserial-miniterm.

```
$ output/host/bin/pyserial-miniterm --raw --eol=LF /dev/ttyUSB0 115200
```
