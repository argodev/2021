# Notes for asmtutor.com

## Lesson 01

_Hello, World!_

This is a simple "hello world" type app. I took the default but added a few lines to ensure that it didn't segfault at the end (properly call `SYS_EXIT`). Otherwise, I left it as it was.

## Lesson 02

_Proper program exit_

Well, had I read ahead, I would have seen that the author addressed the `SYS_EXIT` issue in lesson 2. Since I've already addressed this, I skipped and moved on.

## Lesson 03

_Calculate string length_

This lesson introduces loops, jumps and labels to show how to dynamically calculate the length of a
string. Simple, but clear.

## Interlude

I took some time here to figure out how to create a `Makefile` that would help me keep moving a bit easier. I experimented with a number of different approaches, each time getting a bit closer to what should actually work and also clarifying my understanding along the way. Eventually I ended up with the file included in this directory. It works reasonably well and simply needs to be called bare (e.g. `> make`) to generate the executable files. Specifically running the `clean` target will ensure there are no `*.o` files or executables left in the directory.

## Lesson 04

_Subroutines_

