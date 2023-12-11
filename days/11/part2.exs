defmodule Main do
	defp sum_list([],    acc), do: acc
	defp sum_list([h|t], acc), do: sum_list(t, acc + h)
	defp sum_list(list),       do: sum_list(list, 0)

	defp get_expand_horz_map(rows) do
		for row <- rows do
			row |> Enum.all?(fn tile -> tile != "#" end)
		end
	end

	defp get_expand_vert_map(rows) do
		for x <- 0 .. length(rows) - 1 do
			rows
			|> Enum.map(fn row -> row |> Enum.at(x) end)
			|> Enum.all?(fn tile -> tile != "#" end)
		end
	end

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

	defp distances_between_galaxies(galaxies, expand_horz_map, expand_vert_map) do
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

			{startX, endX} = {min(x1, x2), max(x1, x2)}
			{startY, endY} = {min(y1, y2), max(y1, y2)}

			expand_by = 1000000

			dist1 =
				(expand_vert_map
				|> Enum.slice(startX, endX - startX)
				|> Enum.count(fn x -> x end)) * (expand_by - 1) + (endX - startX)

			dist2 =
				(expand_horz_map
				|> Enum.slice(startY, endY - startY)
				|> Enum.count(fn x -> x end)) * (expand_by - 1) + (endY - startY)

			dist1 + dist2
		end)
	end

	def main() do
		rows =
			File.stream!("input.txt")
			|> Enum.map(&String.trim_trailing/1)
			|> Enum.map(&String.graphemes/1)

		expand_horz_map = rows |> get_expand_horz_map
		expand_vert_map = rows |> get_expand_vert_map

		IO.puts "#{
			rows
			|> get_galaxies
			|> distances_between_galaxies(expand_horz_map, expand_vert_map)
			|> sum_list
		}"
	end
end

Main.main()
