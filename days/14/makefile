CMD   = zig build-exe
PART1 = part1.zig
PART2 = part2.zig

PART1_BIN = $(addsuffix .out,$(basename $(PART1)))
PART2_BIN = $(addsuffix .out,$(basename $(PART2)))

all:
	@echo part1, part2, clean

part1: $(PART1_BIN)
	./$(PART1_BIN)

part2: $(PART2_BIN)
	./$(PART2_BIN)

%.out: %.zig
	$(CMD) $< --name $@

clean:
	rm -f $(PART1_BIN) $(PART1_BIN).o $(PART2_BIN) $(PART2_BIN).o
