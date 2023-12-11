<h1 align="center">🎄 <a href="https://adventofcode.com/2023/day/10">Day 10</a></h1>
<p align="center">In <a href="https://elixir-lang.org/">Elixir</a></p>
<p align="center">
	<img src="https://raw.githubusercontent.com/devicons/devicon/55609aa5bd817ff167afce0d965585c92040787a/icons/elixir/elixir-original.svg" width="50px">
</p>

This was a very interesting day. I enjoyed it actually, even tho i struggled with the functional
mindset. A few times i just couldnt think of a way to write the code without mutable variables and
while loops, but eventually i got it. The code isnt the prettiest, but hey, it works. I still
enjoyed Elixir a lot.

The idea behind part 2 was scanning individual rows. If you see a `|`, youre inside the main loop. If
you encounter it again, youre outside. If you encounter it once again, youre again inside and so
on. This in my mind was a mutable boolean flag that you would switch on and off, so i struggled a
bit making it functional.

There were also corner pipes `F`, `7`, `L` and `J`. Those can be handled easily; If the horizontal
pipe line starts with `F` and ends with `7` (`F-----7`), the "in loop" flag has not changed. If it
however starts with `F` and ends with `J` (`F-----J`), the "in loop" flag changes.

## Quickstart
To run part 1 or part 2, do:
```sh
$ make part1
$ make part2
```
