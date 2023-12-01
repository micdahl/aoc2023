defmodule AOC do
  defp first_digit([head | tail]) do
    case Integer.parse(head) do
      {_, _} -> head
      :error -> first_digit(tail)
    end
  end

  defp extract_digits(line) when line == "" do
    0
  end

  defp extract_digits(line) do
    first =
      line
      |> String.graphemes()
      |> first_digit()

    last =
      line
      |> String.graphemes()
      |> Enum.reverse()
      |> first_digit()

    {result, _} = Integer.parse(first <> last)
    result
  end

  def call do
    [filename] = System.argv()

    File.read!(filename)
    |> String.split("\n")
    |> Enum.map(&extract_digits/1)
    |> Enum.reduce(0, &(&1 + &2))
    |> IO.inspect()
  end
end

AOC.call()
