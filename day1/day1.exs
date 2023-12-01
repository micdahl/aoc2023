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
    |> String.replace("one", "one1one")
    |> String.replace("two", "two2two")
    |> String.replace("three", "three3three")
    |> String.replace("four", "four4four")
    |> String.replace("five", "five5five")
    |> String.replace("six", "six6six")
    |> String.replace("seven", "seven7seven")
    |> String.replace("eight", "eight8eight")
    |> String.replace("nine", "nine9nine")
    |> String.split("\n")
    |> Enum.map(&extract_digits/1)
    |> Enum.reduce(0, &(&1 + &2))
    |> IO.inspect()
  end
end

AOC.call()
