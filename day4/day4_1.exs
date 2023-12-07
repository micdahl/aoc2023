defmodule AOC do
  def call do
    File.read!(System.argv() |> List.first())
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.map(&Enum.fetch!(&1, 1))
    |> Enum.map(&String.split(&1, "|"))
    |> Enum.map(fn [a, b] ->
      [
        String.split(a, " ", trim: true) |> Enum.map(&String.to_integer(&1)),
        String.split(b, " ", trim: true) |> Enum.map(&String.to_integer(&1))
      ]
    end)
    |> Enum.map(fn [winning, having] ->
      having
      |> Enum.reduce(0, fn x, acc ->
        if Enum.member?(winning, x) do
          case acc do
            0 -> 1
            _ -> acc * 2
          end
        else
          acc
        end
      end)
    end)
    |> Enum.sum()
    |> IO.inspect(limit: :infinity)
  end
end

AOC.call()
