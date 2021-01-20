# Week 02: Reversing TL-WR840N

## Links of Interest
* [Paper Link](https://therealunicornsecurity.github.io/TPLink/)
* [TL866II+ High Performance Programmer](https://www.jameco.com/z/TL866II-Plus-Jameco-Valuepro-USB-High-Performance-Programmer_2297823.html)
* [Linux fork of MiniPro utility](https://gitlab.com/DavidGriffith/minipro/)
* [Dropbear SSH](https://matt.ucc.asn.au/dropbear/dropbear.html)

Interesting quote _"All the binaries are compiled for MIPS, that is the most common architecture for routers"_

Intersting approach... having discovered some encrypted/unreadable files, he then did a `strings` search for those filenames across all binaries in the image.

