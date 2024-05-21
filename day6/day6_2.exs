defmodule AOC do
  def in_range?(value, time, record) do
    value * value - value * time + record < 0
  end

  def intervals({time, record}) do
    time_2 = time / 2
    sqrt = :math.sqrt(time * time / 4 - record)
    t1 = time_2 - sqrt
    t2 = time_2 + sqrt

    ranges = [{0, t1}, {t1, t2}, {t2, time}]

    in_ranges =
      Enum.filter(ranges, fn {lower, upper} -> in_range?((lower + upper) / 2, time, record) end)

    Enum.reduce(in_ranges, 0, fn {start, stop}, acc -> acc + abs(floor(stop) - floor(start)) end)
  end

  def number_of_ways_to_beat({time, record}) do
    results =
      Enum.map(Range.new(1, time - 1), fn i ->
        i * (time - i)
      end)

    Enum.count(Enum.filter(results, fn result -> result > record end))
  end

  def call do
    # Time:      7  15   30
    # record:  9  40  200
    input = File.read!(hd(System.argv()))
    [time_line, record_line] = String.split(input, "\n", trim: true)

    time_value_part = Enum.at(String.split(time_line, ":", trim: true), -1)
    time_value = String.to_integer(String.replace(time_value_part, " ", ""))

    record_value_part = Enum.at(String.split(record_line, ":", trim: true), -1)
    record_value = String.to_integer(String.replace(record_value_part, " ", ""))

    intervals({time_value, record_value})
    |> IO.inspect(limit: :infinity, charlists: :as_lists)
  end
end

AOC.call()
