defmodule Main do
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

	defp next_dist(rows, x, y, next, dist) do
		{next_x, next_y} = move(x, y, next)
		pipe = Enum.at(Enum.at(rows, next_y), next_x)

		if pipe == "S" do dist
		else
			dir  = pipe_to_dir(pipe)
			next =
				if dir_cancels(elem(dir, 0), next) do elem(dir, 1)
				else elem(dir, 0) end

			next_dist(rows, next_x, next_y, next, dist + 1)
		end
	end

	defp collect_dists(rows, x, y, next), do: next_dist(rows, x, y, next, 1)

	def main() do
		rows =
			File.stream!("input.txt")
			|> Enum.map(&String.trim_trailing/1)
			|> Enum.map(&String.graphemes/1)

		max_x = length(Enum.at(rows, 0)) - 1
		max_y = length(rows) - 1

		{start_x, start_y} =
			rows
			|> Enum.with_index
			|> Enum.find_value(fn {row, y} ->
				x = Enum.find_index(row, fn tile -> tile == "S" end)
				if x == nil do nil
				else {x, y} end
			end)

		up_ch =
			if start_y - 1 < 0 do nil
			else Enum.at(Enum.at(rows, start_y - 1), start_x) end

		left_ch =
			if start_x - 1 < 0 do nil
			else Enum.at(Enum.at(rows, start_y), start_x - 1) end

		down_ch =
			if start_y + 1 >= max_y do nil
			else Enum.at(Enum.at(rows, start_y + 1), start_x) end

		right_ch =
			if start_x + 1 >= max_x do nil
			else Enum.at(Enum.at(rows, start_y), start_x + 1) end

		first_move =
			cond do
				move_valid(up_ch,    dir_up())    -> dir_up()
				move_valid(left_ch,  dir_left())  -> dir_left()
				move_valid(down_ch,  dir_down())  -> dir_down()
				move_valid(right_ch, dir_right()) -> dir_right()
			end

		IO.puts "#{trunc(collect_dists(rows, start_x, start_y, first_move) / 2)}"
	end
end

Main.main()
