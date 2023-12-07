defmodule AOC do
  @digits ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
  @digits_and_ignorables ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".", "\n"]

  defp is_valid(position, content, line_length) do
    row = Integer.floor_div(position, line_length)
    column = position - row * line_length
    row_length = Integer.floor_div(length(content), line_length)

    [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]]
    |> Enum.filter(fn [column_offset, row_offset] ->
      row + row_offset >= 0 and
        row + row_offset < row_length and
        column + column_offset >= 0 and column + column_offset < line_length
    end)
    |> Enum.map(fn [column_offset, row_offset] ->
      (row + row_offset) * line_length + (column + column_offset)
    end)
    |> Enum.any?(fn position_to_check ->
      Enum.at(content, position_to_check) not in @digits_and_ignorables
    end)
  end

  defp parse([], _, found_numbers, current, true, _, _) do
    Enum.reverse([current] ++ found_numbers)
  end

  defp parse([], _, found_numbers, _, _, _, _) do
    Enum.reverse(found_numbers)
  end

  defp parse(
         [head | tail],
         position,
         found_numbers,
         current,
         valid,
         content,
         line_length
       )
       when head in @digits do
    parse(
      tail,
      position + 1,
      found_numbers,
      current * 10 + String.to_integer(head),
      valid or is_valid(position, content, line_length),
      content,
      line_length
    )
  end

  defp parse([_ | tail], position, found_numbers, current, _, content, line_length)
       when current == 0 do
    parse(
      tail,
      position + 1,
      found_numbers,
      0,
      false,
      content,
      line_length
    )
  end

  defp parse([_ | tail], position, found_numbers, current, true, content, line_length) do
    parse(
      tail,
      position + 1,
      [current] ++ found_numbers,
      0,
      false,
      content,
      line_length
    )
  end

  defp parse([_ | tail], position, found_numbers, _, false, content, line_length) do
    parse(
      tail,
      position + 1,
      found_numbers,
      0,
      false,
      content,
      line_length
    )
  end

  def call do
    [filename] = System.argv()

    content = File.read!(filename)

    content_graphemes =
      content
      |> String.graphemes()

    line_length = content |> String.split("\n") |> List.first() |> String.length()

    content_graphemes
    |> parse(0, [], 0, false, content_graphemes, line_length + 1)
    |> IO.inspect(limit: :infinity)
    |> Enum.sum()
    |> IO.inspect()
  end
end

AOC.call()
