defmodule AOC do
  @digits ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

  defp extract_gearnumbers(found_gears) do
    found_gears |> Map.to_list() |> Enum.reduce(0, fn {_, values}, acc ->
      if Enum.count(values) > 1 do
        acc + Enum.product(values)
      else
        acc
      end
    end)
  end

  defp find_gear_position(position, content, line_length) do
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
    |> Enum.find(fn position_to_check ->
      Enum.at(content, position_to_check) == "*"
    end)
  end

  defp parse([], _, found_gears, current, gear_position, _, _) when gear_position != nil do
    {_, result} = Map.get_and_update(found_gears, gear_position, fn current_value ->
        case current_value do
          nil -> {current_value, [current]}
          _ -> {current_value, [current] ++ current_value}
        end
      end)
      extract_gearnumbers(result)
  end

  defp parse([], _, found_gears, _, _, _, _) do
      extract_gearnumbers(found_gears)
  end

  defp parse(
         [head | tail],
         position,
         found_gears,
         current,
         gear_position,
         content,
         line_length
       )
       when head in @digits do
    if gear_position == nil do
      parse(
        tail,
        position + 1,
        found_gears,
        current * 10 + String.to_integer(head),
        find_gear_position(position, content, line_length),
        content,
        line_length
      )
    else
      parse(
        tail,
        position + 1,
        found_gears,
        current * 10 + String.to_integer(head),
        gear_position,
        content,
        line_length
      )
    end
  end

  defp parse([_ | tail], position, found_gears, current, gear_position, content, line_length) when current == 0 or gear_position == nil do
    parse(
      tail,
      position + 1,
      found_gears,
      0,
      nil,
      content,
      line_length
    )
  end

  defp parse([_ | tail], position, found_gears, current, gear_position, content, line_length) do
    {_, new_found_gears} = Map.get_and_update(found_gears, gear_position, fn current_value ->
      case current_value do
        nil -> {current_value, [current]}
        _ -> {current_value, [current] ++ current_value}
      end
    end)
    parse(
      tail,
      position + 1,
      new_found_gears,
      0,
      nil,
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
    |> parse(0, %{}, 0, nil, content_graphemes, line_length + 1)
    |> IO.inspect(limit: :infinity)
  end
end

AOC.call()
