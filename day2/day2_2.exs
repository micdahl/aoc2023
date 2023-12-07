defmodule AOC do
  # Sample line: Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue

  defp parse_color(set) do
    [count, color] = String.split(set, " ")
    [String.to_atom(color), String.to_integer(count)]
  end

  defp parse_set(setlist) do
    String.split(setlist, ", ")
    |> Enum.map(&parse_color(&1))
  end

  def parse_setlist(setlist) do
    String.split(setlist, "; ")
    |> Enum.map(&parse_set(&1))
  end

  defp parse_gamenumber(game_with_number) do
    [_, game_number] = String.split(game_with_number, " ")
    String.to_integer(game_number)
  end

  defp parse_game(game) do
    [game_with_number, setlist] = String.split(game, ": ")
    [parse_gamenumber(game_with_number), parse_setlist(setlist)]
  end

  def call do
    [filename] = System.argv()

    File.read!(filename)
    |> String.split("\n")
    |> Enum.filter(fn line -> String.contains?(line, "Game") end)
    |> Enum.map(&parse_game(&1))
    |> Enum.map(fn [_, setlist] ->
      Enum.reduce(setlist, %{red: 0, green: 0, blue: 0}, fn set, acc ->
        Enum.reduce(set, acc, fn [color, count], acc ->
          if count > acc[color] do
            Map.put(acc, color, count)
          else
            acc
          end
        end)
      end)
    end)
    |> Enum.map(fn %{red: red, green: green, blue: blue} ->
      red * green * blue
    end)
    |> Enum.sum()
    |> IO.inspect()
  end
end

AOC.call()
