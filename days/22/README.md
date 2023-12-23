<h1 align="center">🎄 <a href="https://adventofcode.com/2023/day/22">Day 22</a></h1>
<p align="center">In <a href="http://cplusplus.com/">C++</a></p>
<p align="center">
	<img src="https://raw.githubusercontent.com/devicons/devicon/55609aa5bd817ff167afce0d965585c92040787a/icons/cplusplus/cplusplus-original.svg" width="50px">
</p>

A 3D problem that seemed like it shouldnt be too hard to solve with a dumber approach. I decided to
create a 3D map of the bricks in memory and operate on that to make the bricks fall and then detect
which are disintegratable. It worked on the example, but on the actual input the result is off by
10. The result is 451, but the program is giving 461. Ive been trying to find out whats wrong for
hours, but debugging a 3D problem with this many bricks is very hard. I give up on it for now,
maybe will return to it in the future. I left the debug printing commented out in the source code.

Though after the few hours of debugging, i came to the conclusion that there is probably something
wrong with the bricks falling code. I have no idea what could be wrong there though.

## Quickstart
To run part 1 or part 2, do:
```sh
$ make part1
$ make part2
```
