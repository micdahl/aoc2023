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
    |> String.replace("one", "o1e")
    |> String.replace("two", "t2o")
    |> String.replace("three", "t3e")
    |> String.replace("four", "f4r")
    |> String.replace("five", "f5e")
    |> String.replace("six", "s6x")
    |> String.replace("seven", "s7n")
    |> String.replace("eight", "e8t")
    |> String.replace("nine", "n9e")
    |> String.split("\n")
    |> Enum.map(&extract_digits/1)
    |> Enum.reduce(0, &(&1 + &2))
    |> IO.inspect()
  end
end

AOC.call()
