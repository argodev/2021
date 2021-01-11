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

## Chapter 5: The Right to Assemble

## Chapter 6: A Place to Stand, with Access to Tools

## Chapter 7: Following your Instructions

## Chapter 8: Our Object All Sublime

## Chapter 9: Bits, Flags, Branches, and Tables

## Chapter 10: Dividing and Conquering

## Chapter 11: Strings and Things

## Chapter 12: Heading Out to C

