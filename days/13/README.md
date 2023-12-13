<h1 align="center">🎄 <a href="https://adventofcode.com/2023/day/13">Day 13</a></h1>
<p align="center">In <a href="https://ziglang.org/">Zig</a></p>
<p align="center">
	<img src="https://raw.githubusercontent.com/devicons/devicon/55609aa5bd817ff167afce0d965585c92040787a/icons/zig/zig-original.svg" width="50px">
</p>

A simpler day, didnt need any hints thankfully. Tho in the first part i made a mistake which caused
a bug that wouldnt count mirrors like

```
v.##..#...#.#.v
^.##..#...#.#.^
 .....#..####.
 .##.#.#..###.
 .##...#..#..#
 #####.##.#.#.
 #.##.#..#.#.#
```

where the mirror is horizontal on the first row. I didnt have much time today to spend tracking the
bug down myself so i used someone elses code to find out what the correct output was and then found
which mirrors my code got wrong and realised that it doesnt count mirrors that are on the first
row or first column.

Part 2 was pretty easy and i had no problems. Pretty fun day and im enjoying Zig so far, though not
as much as Elixir.

## Quickstart
To run part 1 or part 2, do:
```sh
$ make part1
$ make part2
```
