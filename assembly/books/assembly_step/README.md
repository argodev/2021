# Assembly Language Step by Step

This book, [Assembly Language Step by Step](https://amzn.to/3946Wpi) by Jeff Duntemann, is not particularly new. The copy I am reading through was published in 2009 and is, unfortunately for me, focused on 32-bit Linux rather than a 64-bit variant. However, after working through a few introductory videos to get in the right head space, I decided that this book was probably a well-structured approach to get me thinking more deeply about Assembly Language in general. It is likely that any system I study specifically will use its own variant, so I'm more interested in the strong concepts and overall flow than I am the specifics of Intel-based 32-bit assembly.

## Chapter 1: Another Pleasant Valley Saturday

> The notes for this chapter were compiled a few weeks after I read it, so they may be a bit jilted or otherwise out of sorts

_"A computer program is a list of steps and tests, nothing more"_

He introduces a "cheezy" board game that, more or less, maps to the notion of a computer program. Most of the remainder of the chapter is simply him explaining the game, and then showing how the metaphor maps over to a computer program. In all, it is a well-thought-out analogy and does help explain things.

## Chapter 2: Alien Bases

The stated purpose of this chapter is to introduce and build familiarity with Binary and Hexadecimal number bases.

He starts by introducing a completely fictious numbering system (_fooby_) and uses that to demonstrate how number bases work. It is a clear-enough example, however I found the funny names overly distracting. 

_"In any given number base, the base itself can never be expressed in a single digit!"_

"Each column has a value _base_ times that of the column to its right. (The rightmost column is units.)"

At this point (around page 28) he has described number bases fairly well, shown a fake one, shown a real one (hex) and walked through how they work. Now he sets out to teach a few approaches for converting between bases (_without using a calculator_).

"The best (actually, the only) way to get a gut feel for hex notation is to use it al lot." I hate this quote, but it is likely correct. As such, I took the time to work through (by hand) each of the practice problems listed in the book.

After working through a number of the problems by hand, I actually took the author's advice and created (via [quizlet](https://quizlet.com)) a series of flashcards for practicing hex-based math. I have included a CSV file that can be used to create your own [here](hexmath.csv).

Now, he switches over to focus on binary.

Nothing particularly magic here... essentially shows that binary uses the same conversion methods as any other number base. 

Possibly helpfully, however he shows that hex can be a shorthand for binary. Every four binary bits (starting from the right) can be represented as a single hex character. In this fashion, the computer *always* operates in binary, but we use Hex as a type of shorthand for making it easier to understand. This short hand, however, does *not* change the actual values.

```
1111 0000 0000 0000 1111 1010 0110 1110
  F    0    0    0    F    A    6    E
```

or, `0xF000FA6E`


## Chapter 3: Lifting the Hood

[COMSACE ELF Simulator](https://billr.incolor.com/computer_simulators.htm)

## Chapter 4: Location, Location, Location

> The skill of assembly language consists of a deep comprehension of memory addressing

### Memory Models:

1. Real mode flat model
1. Real mode segmented model
1. protected mode flat model

While I haven't written a great deal of notes here, this chapter was quite helpful in filling-out my understanding of the memory models and how the "address space" works for programs (both 32 and 64-bit). Unfortunately, I would have said that this was all quite a mystery to me previously - especially with respect to how physical/real memory maps over to the memory space exposed to programs. Additionally, the history and progression information was helpful background information (e.g. what is "protected mode" and why it matters).

## Chapter 5: The Right to Assemble

This chapter was another "intro" style chapter that provided some strong background. Right near the end, it jumps into walking you through actually creating a program - one that writes a little message to standard out and then exits. I diverged from the path suggested in the book and a.) manually entered the source code and b.) used the debugger interface in VSCode (combined with GDB) to do the debugging. A couple of notes:

1. On modern (x64) systems, you need to explicitly compile for 32 bit if that is desired:

   ```bash
   nasm -f elf -g -F stabs eatsyscall.asm
   ```

1. Similarly, you need to explicity link for 32-bit if desired

   ```bash
   ld -m elf_i386 -o eatsyscall eatsyscall.o
   ```

1. Since VSCode is not natively configured to debug assembly programs, you cannot simply set a breakpoint in your `*.asm` file and hit 'debug'. Instead, you can create a debug configuration (see the `launch.json` file) and then, in debug view, set a breakpoint on the function you wish to stop on (e.g. `_start`). Once you do this, you can then execute gdb-style commands as you normally would such as:

   ```bash
   -exec disassemble
   ```

> NOTE: You may get the error: `&"warning: GDB: Failed to set controlling terminal: Operation not permitted\n"` when running the debugger. This is a known issue and can be ignored.

All of the above considered, I find it a bit easier to use `pwntools` with `gdb` directly. Simply run `gdb eatsyscall` followed by `break _start` and `run` and you are golden. You can than step (`s`) through the code and watch it run while seeing the stack, registers, etc.

## Chapter 6: A Place to Stand, with Access to Tools

This chapter was a reasonably quick read. Author spent a fair amount of time describing a tool set (`kate`) that I have no intention to use. I did review the pages and ensured that the things I needed would be provided in my chosen editor/tool chain: vscode and/or vim. 

I slowed down a bit in the section on makefiles. As dumb as it sounds, I've never had a good intro to these and always "just figured it out". Here, the author's explanation makes a ton of sense, and I created and tested my own. I expect this will help me moving forward.

Ends the chapter with a discussion of another debugger that I don't intend to use (insight). My plan is to either use gdb directly (with pwntools) or use gdb as integrated with vscode.

## Chapter 7: Following your Instructions

## Chapter 8: Our Object All Sublime

## Chapter 9: Bits, Flags, Branches, and Tables

## Chapter 10: Dividing and Conquering

## Chapter 11: Strings and Things

## Chapter 12: Heading Out to C

