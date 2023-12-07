defmodule AOC do
  def call do
    input =
      File.read!(System.argv() |> List.first())
      |> String.split("\n", trim: true)

    input
    |> Enum.reject(fn x -> x == "" end)
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.map(&Enum.fetch!(&1, 1))
    |> Enum.map(&String.split(&1, "|"))
    |> Enum.map(fn [a, b] ->
      [
        String.split(a, " ", trim: true) |> Enum.map(&String.to_integer(&1)),
        String.split(b, " ", trim: true) |> Enum.map(&String.to_integer(&1))
      ]
    end)
    |> Enum.reduce(
      [0, Enum.map(Enum.to_list(0..(Enum.count(input) - 1)), fn x -> [x, 1] end)],
      fn [
           winnings,
           havings
         ],
         out_acc ->
        [index, result] = out_acc
        [_, current_value] = Enum.at(result, index)

        wins =
          havings
          |> Enum.reduce(0, fn x, acc ->
            if Enum.member?(winnings, x) do
              acc + 1
            else
              acc
            end
          end)

        case wins do
          nil ->
            [index + 1, result]

          _ ->
            [
              index + 1,
              Enum.map(result, fn [idx, val] ->
                if idx > index and idx <= index + wins do
                  [idx, val + current_value]
                else
                  [idx, val]
                end
              end)
            ]
        end
      end
    )
    |> Enum.at(1)
    |> Enum.reduce(0, fn [_, val], acc ->
      acc + val
    end)
    |> IO.inspect(limit: :infinity)
  end
end

AOC.call()
