<h1 align="center">🎄 <a href="https://adventofcode.com/2023/day/16">Day 16</a></h1>
<p align="center">In <a href="https://nim-lang.org/">Nim</a></p>
<p align="center">
	<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Nim_logo.svg/1200px-Nim_logo.svg.png" width="50px">
</p>

Day 16 was really fun and easy, again. Part 1 tricked me because there was a path that got stuck so
the program was crashing due to recursion limits and i had to debug what was going on, but then
i figured out it was because it was getting stuck in a loop so i wrote a simple detection that would
not enter infinite loops. Given what part 1 was, i was scared of what part 2 will be and when i got
to it, i thought i would have to do some optimizations, some memoization and stuff, but i as always
first tried a naive approach and it already took only 600ms which is fast enough.

So far tho im really liking Nim. Maybe even more than Zig.

## Quickstart
To run part 1 or part 2, do:
```sh
$ make part1
$ make part2
```
