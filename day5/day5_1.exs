defmodule AOC do
  def call do
    input = File.read!(System.argv() |> List.first())

    [seed_str | maps] =
      String.split(input, "\n\n", trim: true)

    seeds =
      Enum.at(String.split(seed_str, ":", trim: true), -1)
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)

    mappings =
      Enum.map(maps, fn map ->
        [heading, values] = String.split(map, ":\n", trim: true)
        [heading_description, _] = String.split(heading, " ", trim: true)
        [source, _, destination] = String.split(heading_description, "-", trim: true)

        value_rows =
          String.split(values, "\n", trim: true)

        ranges =
          Enum.map(value_rows, fn row ->
            String.split(row, " ", trim: true)
            |> Enum.map(&String.to_integer/1)
          end)
          |> Enum.sort_by(fn [source, _, _] -> source end)

        [source, destination, ranges]
      end)

    mappings
    |> Enum.reduce(seeds, fn [_source, _destination, ranges], acc ->
      acc
      |> IO.inspect(limit: :infinity, charlists: :as_lists)
      |> Enum.map(fn source_value ->
        index =
          Enum.find_index(ranges, fn [_, source_range_start, range_length] ->
            source_value in source_range_start..(source_range_start + range_length)
          end)

        [destination_range_start, source_range_start, range_length] =
          case index do
            nil -> Enum.at(ranges, -1)
            _ -> Enum.at(ranges, index)
          end

        if source_value in source_range_start..(source_range_start + range_length) do
          destination_range_start + (source_value - source_range_start)
        else
          source_value
        end
      end)
    end)
    |> Enum.sort()
    |> Enum.at(0)
    |> IO.inspect(limit: :infinity, charlists: :as_lists)
  end
end

AOC.call()
