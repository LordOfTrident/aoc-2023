defmodule Main do
	defp sum_list([],    acc), do: acc
	defp sum_list([h|t], acc), do: sum_list(t, acc + h)
	defp sum_list(list),       do: sum_list(list, 0)

	defp list_insert(list, pos, thing) do
		Enum.slice(list, 0, pos) ++ [thing] ++ Enum.slice(list, pos, length(list))
	end

	defp expand_universe_horz(rows, y) do
		if y < length(rows) do
			row = rows |> Enum.at(y)
			if row |> Enum.all?(fn tile -> tile == "." end) do
				rows
				|> list_insert(y, row)
				|> expand_universe_horz(y + 2)
			else
				rows |> expand_universe_horz(y + 1)
			end
		else
			rows
		end
	end

	defp expand_universe_vert(rows, x) do
		if x < length(Enum.at(rows, 0)) do
			col = rows |> Enum.map(fn row -> row |> Enum.at(x) end)
			if col |> Enum.all?(fn tile -> tile == "." end) do
				rows
				|> Enum.map(fn row -> row |> list_insert(x, ".") end)
				|> expand_universe_vert(x + 2)
			else
				rows |> expand_universe_vert(x + 1)
			end
		else
			rows
		end
	end

	defp expand_universe(rows) do
		rows
		|> expand_universe_horz(0)
		|> expand_universe_vert(0)
	end

	# My first function pattern matching experiment
	defp get_galaxies_in_row(_row, _x, _y, nil, result), do: result

	defp get_galaxies_in_row(row, x, y, "#", result), do:
		row |> get_galaxies_in_row(x + 1, y, row |> Enum.at(x + 1), result ++ [{x, y}])

	defp get_galaxies_in_row(row, x, y, _, result), do:
		row |> get_galaxies_in_row(x + 1, y, row |> Enum.at(x + 1), result)

	defp get_galaxies(rows) do
		rows
		|> Enum.with_index
		|> Enum.flat_map(fn {row, y} ->
			row |> get_galaxies_in_row(0, y, row |> Enum.at(0), [])
		end)
	end

	defp distances_between_galaxies(galaxies) do
		for {a, x} <- galaxies |> Enum.with_index,
		    {b, y} <- galaxies |> Enum.with_index,
		    a != b
		do
			if x > y do [a, b]
			else [b, a] end
		end
		|> Enum.uniq
		|> Enum.map(fn pair ->
			{x1, y1} = pair |> Enum.at(0)
			{x2, y2} = pair |> Enum.at(1)

			abs(x2 - x1) + abs(y2 - y1)
		end)
	end

	def main() do
		IO.puts "#{
			File.stream!("input.txt")
			|> Enum.map(&String.trim_trailing/1)
			|> Enum.map(&String.graphemes/1)
			|> expand_universe
			|> get_galaxies
			|> distances_between_galaxies
			|> sum_list
		}"
	end
end

Main.main()
