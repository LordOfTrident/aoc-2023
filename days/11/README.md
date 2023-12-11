<h1 align="center">🎄 <a href="https://adventofcode.com/2023/day/11">Day 11</a></h1>
<p align="center">In <a href="https://elixir-lang.org/">Elixir</a></p>
<p align="center">
	<img src="https://raw.githubusercontent.com/devicons/devicon/55609aa5bd817ff167afce0d965585c92040787a/icons/elixir/elixir-original.svg" width="50px">
</p>

Another fun day with a problem that wasnt hard. Again had to think when implementing it using a
functional language, but it went fine. I did my first recursive function with pattern matching
experiment (i took the tail call optimized sum_list implementation from google, so that wasnt my
first function with pattern matching :D). The code before i tried the pattern matching was this:

```elixir
defp get_galaxies_in_row(row, x, y, result) do
	if x < length(row) do
		if row |> Enum.at(x) == "#" do
			row |> get_galaxies_in_row(x + 1, y, result ++ [{x, y}])
		else
			row |> get_galaxies_in_row(x + 1, y, result)
		end
	else
		result
	end
end
```

and after i applied pattern matching:

```elixir
defp get_galaxies_in_row(_row, _x, _y, nil, result), do: result

defp get_galaxies_in_row(row, x, y, "#", result), do:
	row |> get_galaxies_in_row(x + 1, y, row |> Enum.at(x + 1), result ++ [{x, y}])

defp get_galaxies_in_row(row, x, y, _, result), do:
	row |> get_galaxies_in_row(x + 1, y, row |> Enum.at(x + 1), result)
```

Though it isnt the most beautiful, it did the job. As with Rust, after 3 days with Elixir im gonna
switch langs. Tho i liked Elixir so much that i might return to it in the later days.

## Quickstart
To run part 1 or part 2, do:
```sh
$ make part1
$ make part2
```
