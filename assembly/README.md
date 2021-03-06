# Assembly Language

## Contents
* [Introduction](#introduction)
* [Books of Interest](#books-of-interest)
* [Videos of Interest](#videos-of-interest)
* [Cheat Sheets](#cheat-sheets)
* [Miscellany](#miscellany)

## Introduction

It seems that nearly all of the tools used in Vulnerability Science generate (or expose) assembly language at some point. You see it in stack traces, you see it in `gdb` outputs, you see it in `Ghidra` outputs, you see it all over the place. As such, it seems like a logical place to begin the year.

## Books of Interest

* [Assembly Language Step by Step](https://amzn.to/3946Wpi), Jeff Duntemann
* [Beginning X64 Assembly Programming](https://amzn.to/2X9lwGz), Jo Van Hoey
* [Modern X86 Assembly Language Programming](https://amzn.to/3rUmNj2), Daniel Kusswurm
* [Programming with 64-Bit ARM Assembly Language: Single Board Computer Development for Raspberry Pi and Mobile Devices](https://amzn.to/3hFrPez), Stephen Smith
* [Raspberry Pi Assembly Language Programming: ARM Processor Coding](https://amzn.to/38YNj1X), Stephen Smith

## Videos of Interest

* [Why should I learn assembly language in 2020? (complete waste of time?)](https://www.youtube.com/watch?v=iYRl50gtprA), [Jacob Sorber](https://www.youtube.com/channel/UCwd5VFu4KoJNjkWJZMFJGHQ)
* [Assembly Language Tutorial](https://www.youtube.com/watch?v=ViNnfoE56V8), [Derek Banas](https://www.youtube.com/channel/UCwRXb5dUK4cvsHbx-rGzSgw)
* [Assembly Language Tutorial 2](https://www.youtube.com/watch?v=5HILZon7pVE), [Derek Banas](https://www.youtube.com/channel/UCwRXb5dUK4cvsHbx-rGzSgw)
* [Assembly Language Tutorial 3](https://www.youtube.com/watch?v=2ghL_R5CSaI), [Derek Banas](https://www.youtube.com/channel/UCwRXb5dUK4cvsHbx-rGzSgw)
* [Assembly Language Tutorial 4](https://www.youtube.com/watch?v=zj-cGdNpYZ8), [Derek Banas](https://www.youtube.com/channel/UCwRXb5dUK4cvsHbx-rGzSgw)
* [x86 Assembly: Hello World!](https://www.youtube.com/watch?v=HgEGAaYdABA), [John Hammond](https://www.youtube.com/channel/UCVeW9qkBjo3zosnqUbG7CFw)
* [x86_64 Linux Assembly](https://www.youtube.com/playlist?list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn), [kupala](https://www.youtube.com/user/khoraski)
   * I walked through this in its entirety and found it a great/soft intro
   * notes and examples [are available](youtubers/kupala/README.md)


## Cheat Sheets 


## Miscellany

Easy way to get `clang` to give you the assembly-language version of your program:

```bash
clang -S hello.c
```

This will yield a `*.s` file (check out the `scratch` directory)


systemcalls are defined in `unistd.h` (64-bit) and `unistd_32.h` in `/usr/include/x86_64-linux-gnu/asm/` on Ubuntu


Build a 32-bit hello-world

```bash

# open the linux programmer's manual, looking at the signature for "write"
man 2 write

# create the 32-bit object file
nasm -f elf32 -o hello_world.o hello_world.asm

# run the linker and create the executable
ld -m elf_i386 -o hello_world hello_world.o

# run the executeable
./hello_world

```

---
* [Back to Top](#assembly-language)
* [Back to Home](../README.md)