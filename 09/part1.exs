defmodule Main do
	defp sum_list([],    acc), do: acc
	defp sum_list([h|t], acc), do: sum_list(t, acc + h)
	defp sum_list(list),       do: sum_list(list, 0)

	defp generate_next_sequence(current, list) do
		result =
			current
			|> Enum.drop(-1)
			|> Enum.with_index
			|> Enum.map(fn {a, i} -> Enum.at(current, i + 1) - a end)

		if not Enum.all?(result, fn x -> x == 0 end) do
			generate_next_sequence(result, list ++ [current])
		else
			list ++ [current, result]
		end
	end

	defp generate_sequences(base), do: generate_next_sequence(base, [])

	defp next_value_in_history(history) do
		generate_sequences(history)
		|> Enum.map(fn line -> Enum.at(line, -1) end)
		|> sum_list
	end

	def main() do
		IO.puts "#{
			File.stream!("input.txt")
			|> Enum.map(fn line ->
				String.split(line, " ")
				|> Enum.map(fn x -> elem(Integer.parse(x), 0) end)
			end)
			|> Enum.map(fn line -> next_value_in_history(line) end)
			|> sum_list
		}"
	end
end

Main.main()
