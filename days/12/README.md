<h1 align="center">🎄 <a href="https://adventofcode.com/2023/day/12">Day 12</a></h1>
<p align="center">In <a href="https://ziglang.org/">Zig</a></p>
<p align="center">
	<img src="https://raw.githubusercontent.com/devicons/devicon/55609aa5bd817ff167afce0d965585c92040787a/icons/zig/zig-original.svg" width="50px">
</p>

Very annoying day. I hate combinations, permutations and stuff like that. Its always annoying. This
day was apparently "DP" ([Dynamic Programming](https://en.wikipedia.org/wiki/Dynamic_programming)),
which im not familiar with at all. I needed to look at a ton of hints to solve it. Rewrote it a
bunch of times but at last got it working.

Part 2 was extremely slow and after a while of trying to figure out what to do, i found out that i
need to use [memoization](https://en.wikipedia.org/wiki/Memoization). In short, its basically
storing results of expensive functions and reusing the stored results if the same input is passed
again instead of re-calculating it. It seems like quite a reasonable and obvious concept but ive
never heard of it until now.

That aside, Zig is just like i remember it from AOC 2022 - pretty nice.

## Quickstart
To run part 1 or part 2, do:
```sh
$ make part1
$ make part2
```
