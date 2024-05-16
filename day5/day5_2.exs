defmodule AOC do
  def seed_values_to_ranges([], _creator), do: []

  def seed_values_to_ranges([x, y | rest], creator) do
    [%{start: x, end: x + y - 1, creator: creator} | seed_values_to_ranges(rest, creator)]
  end

  def call do
    input = File.read!(hd(System.argv()))

    [seed_str | maps] =
      String.split(input, "\n\n", trim: true)

    seed_ranges =
      seed_values_to_ranges(
        Enum.at(String.split(seed_str, ":", trim: true), -1)
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1),
        "seed"
      )

    mappings =
      Enum.map(maps, fn map ->
        String.split(map, " map:\n")
      end)
      |> Enum.map(fn [name, values] ->
        %{
          name: name,
          values:
            String.split(values, "\n", trim: true)
            |> Enum.map(fn value_line ->
              String.split(value_line)
              |> Enum.map(&String.to_integer/1)
            end)
            |> Enum.map(fn [destination_range_start, source_range_start, range_length] ->
              %{
                start: source_range_start,
                end: source_range_start + range_length - 1,
                offset: destination_range_start - source_range_start
              }
            end)
        }
      end)

    Enum.reduce(mappings, seed_ranges, fn mapping, acc1 ->
      Enum.reduce(mapping.values, acc1, fn mapping_range, acc2 ->
        Enum.flat_map(acc2, fn seed_range ->
          cond do
            seed_range.creator == mapping.name ->
              [seed_range]

            seed_range.end < mapping_range.start ->
              [seed_range]

            seed_range.start > mapping_range.end ->
              [seed_range]

            seed_range.start < mapping_range.start and seed_range.end <= mapping_range.end ->
              [
                %{
                  start: seed_range.start,
                  end: mapping_range.start - 1,
                  creator: seed_range.creator
                },
                %{
                  start: mapping_range.start + mapping_range.offset,
                  end: seed_range.end + mapping_range.offset,
                  creator: mapping.name
                }
              ]

            seed_range.start < mapping_range.start and seed_range.end > mapping_range.end ->
              [
                %{
                  start: seed_range.start,
                  end: mapping_range.start - 1,
                  creator: seed_range.creator
                },
                %{
                  start: mapping_range.start + mapping_range.offset,
                  end: mapping_range.end + mapping_range.offset,
                  creator: mapping.name
                },
                %{start: mapping_range.end + 1, end: seed_range.end, creator: seed_range.creator}
              ]

            seed_range.start >= mapping_range.start and seed_range.end <= mapping_range.end ->
              [
                %{
                  start: seed_range.start + mapping_range.offset,
                  end: seed_range.end + mapping_range.offset,
                  creator: mapping.name
                }
              ]

            seed_range.start >= mapping_range.start and seed_range.end > mapping_range.end ->
              [
                %{
                  start: seed_range.start + mapping_range.offset,
                  end: seed_range.end + mapping_range.offset,
                  creator: mapping.name
                },
                %{start: mapping_range.end + 1, end: seed_range.end, creator: seed_range.creator}
              ]
          end
        end)
      end)
    end)
    |> Enum.sort(&(&1.start < &2.start))
    |> Enum.at(0)
    |> IO.inspect(limit: :infinity, charlists: :as_lists)
  end
end

AOC.call()
