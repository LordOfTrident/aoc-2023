defmodule Main do
	defp sum_list([],    acc), do: acc
	defp sum_list([h|t], acc), do: sum_list(t, acc + h)
	defp sum_list(list),       do: sum_list(list, 0)

	defp dir_up(),    do: 1
	defp dir_left(),  do: 2
	defp dir_down(),  do: 3
	defp dir_right(), do: 4

	def move(x, y, dir) do
		cond do
			dir == dir_up()    -> {x, y - 1}
			dir == dir_left()  -> {x - 1, y}
			dir == dir_down()  -> {x, y + 1}
			dir == dir_right() -> {x + 1, y}
		end
	end

	defp pipe_is(pipe, pipes) do
		result =
			pipes
			|> String.graphemes
			|> Enum.find(fn x -> x == pipe end)

		if result == nil do false
		else true end
	end

	defp move_valid(pipe, dir) do
		cond do
			dir == dir_up()    and pipe_is(pipe, "|F7") -> true
			dir == dir_left()  and pipe_is(pipe, "-LF") -> true
			dir == dir_down()  and pipe_is(pipe, "|LJ") -> true
			dir == dir_right() and pipe_is(pipe, "-J7") -> true
			true -> false
		end
	end

	defp pipe_to_dir(pipe) do
		case pipe do
			"|" -> {dir_up(),    dir_down()}
			"-" -> {dir_left(),  dir_right()}
			"7" -> {dir_left(),  dir_down()}
			"F" -> {dir_right(), dir_down()}
			"J" -> {dir_left(),  dir_up()}
			"L" -> {dir_right(), dir_up()}
		end
	end

	defp dir_cancels(dir_a, dir_b) do
		(dir_a == dir_up()   and dir_b == dir_down())  or
		(dir_a == dir_left() and dir_b == dir_right()) or
		(dir_b == dir_up()   and dir_a == dir_down())  or
		(dir_b == dir_left() and dir_a == dir_right())
	end

	defp rows_replace_at(rows, x, y, tile) do
		rows |> List.update_at(y, fn row ->
			row |> List.update_at(x, fn _ -> tile end)
		end)
	end

	defp mark_main_loop(rows, x, y, next, start_pipe) do
		{next_x, next_y} = move(x, y, next)
		{_in_loop, pipe} = Enum.at(Enum.at(rows, next_y), next_x)

		if pipe == "S" do
			rows_replace_at(rows, next_x, next_y, {true, start_pipe})
		else
			dir  = pipe_to_dir(pipe)
			next =
				if dir_cancels(elem(dir, 0), next) do elem(dir, 1)
				else elem(dir, 0) end

			new_rows = rows_replace_at(rows, next_x, next_y, {true, pipe})
			mark_main_loop(new_rows, next_x, next_y, next, start_pipe)
		end
	end

	defp row_count_next(row, x, is_in_loop, count, is_in_horiz, horiz_ch) do
		if x >= length(row) do count
		else
			{in_loop, pipe} = Enum.at(row, x)

			{is_in_loop, is_in_horiz, horiz_ch} =
				cond do
					in_loop and pipe == "|" -> {not is_in_loop, false, horiz_ch}
					in_loop and pipe_is(pipe, "F7LJ") ->
						cond do
							is_in_horiz and
							((horiz_ch == "F" and pipe == "7") or
							 (horiz_ch == "L" and pipe == "J")) -> {is_in_loop, false, " "}

							is_in_horiz -> {not is_in_loop, false, " "}

							true -> {is_in_loop, true, pipe}
						end

					true -> {is_in_loop, is_in_horiz, horiz_ch}
				end

			count =
				if is_in_loop and not in_loop do count + 1
				else count end

			row_count_next(row, x + 1, is_in_loop, count, is_in_horiz, horiz_ch)
		end
	end

	defp row_count_inside(row), do: row_count_next(row, 0, false, 0, false, " ")

	def main() do
		rows =
			File.stream!("input.txt")
			|> Enum.map(&String.trim_trailing/1)
			|> Enum.map(&String.graphemes/1)
			|> Enum.map(fn line -> Enum.map(line, fn tile -> {false, tile} end) end)

		max_x = length(Enum.at(rows, 0)) - 1
		max_y = length(rows) - 1

		{start_x, start_y} =
			rows
			|> Enum.with_index
			|> Enum.find_value(fn {row, y} ->
				x = Enum.find_index(row, fn {_is_loop, tile} -> tile == "S" end)
				if x == nil do nil
				else {x, y} end
			end)

		up_ch =
			if start_y - 1 < 0 do nil
			else elem(Enum.at(Enum.at(rows, start_y - 1), start_x), 1) end

		left_ch =
			if start_x - 1 < 0 do nil
			else elem(Enum.at(Enum.at(rows, start_y), start_x - 1), 1) end

		down_ch =
			if start_y + 1 >= max_y do nil
			else elem(Enum.at(Enum.at(rows, start_y + 1), start_x), 1) end

		right_ch =
			if start_x + 1 >= max_x do nil
			else elem(Enum.at(Enum.at(rows, start_y), start_x + 1), 1) end

		start_pipe =
			cond do
				move_valid(up_ch,   dir_up())   and move_valid(down_ch,  dir_down())  -> "|"
				move_valid(left_ch, dir_left()) and move_valid(right_ch, dir_right()) -> "-"
				move_valid(down_ch, dir_down()) and move_valid(right_ch, dir_right()) -> "F"
				move_valid(down_ch, dir_down()) and move_valid(left_ch,  dir_left())  -> "7"
				move_valid(up_ch,   dir_up())   and move_valid(right_ch, dir_right()) -> "L"
				move_valid(up_ch,   dir_up())   and move_valid(left_ch,  dir_left())  -> "J"
			end

		IO.puts "#{
			rows
			|> mark_main_loop(start_x, start_y, elem(pipe_to_dir(start_pipe), 0), start_pipe)
			|> Enum.map(fn row -> row_count_inside(row) end)
			|> sum_list
		}"
	end
end

Main.main()
