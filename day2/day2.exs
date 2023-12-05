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
    max = [red: 12, green: 13, blue: 14]

    File.read!(filename)
    |> String.split("\n")
    |> Enum.filter(fn line -> String.contains?(line, "Game") end)
    |> Enum.map(&parse_game(&1))
    |> Enum.filter(fn [_, setlist] ->
      Enum.all?(setlist, fn set ->
        Enum.all?(set, fn [color, count] ->
          count <= max[color]
        end)
      end)
    end)
    |> Enum.reduce(0, fn [game_number, _], acc ->
      acc + game_number
    end)
    |> IO.inspect()
  end
end

AOC.call()
