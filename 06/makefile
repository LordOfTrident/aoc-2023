CMD   = rustc
PART1 = part1.rs
PART2 = part2.rs

PART1_BIN = $(addsuffix .out,$(basename $(PART1)))
PART2_BIN = $(addsuffix .out,$(basename $(PART2)))

all:
	@echo part1, part2, clean

part1: $(PART1_BIN)
	./$(PART1_BIN)

part2: $(PART2_BIN)
	./$(PART2_BIN)

%.out: %.rs
	$(CMD) $< -o $@

clean:
	rm -f $(PART1_BIN) $(PART2_BIN)
