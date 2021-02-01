
lessons := $(wildcard *.asm)
objects := $(patsubst %.asm,%.o,$(wildcard *.asm))
runnables := $(basename $(lessons))


# Keys to remember
# $< is the first dependency
# $@ is the target

buildall: $(runnables)
	@$(foreach runnable,$(runnables), echo Built: $(runnable);)

# generic rule/target stating I need X.o in order build X
%: %.o
	ld -m elf_i386 -o $@ $<

# generic rule/target stating I need X.asm in order build X.o
%.o: %.asm
	nasm -f elf -g -F stabs $<

clean:
	-rm $(runnables) $(objects)
