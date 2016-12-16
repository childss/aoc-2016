defmodule AdventOfCode do
  def main(args) do
    args
    |> parse_args
    |> process
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      switches: [day: :string, part: :string]
    )
    options
  end

  defp process([all: true]) do
    day_re = ~r/day(\d+)/
    highest = "lib"
      |> File.ls!
      |> Enum.filter(&Regex.match?(day_re, &1))
      |> Enum.map(fn f -> 
        [day] = Regex.run(day_re, f, capture: :all_but_first)
        String.to_integer(day)
      end)
      |> Enum.max

    Enum.each(1..highest, &run(&1, [1, 2]))
  end
  defp process([day: day, part: part]) do
    run(day, [part])
  end
  defp process([day: day]) do
    run(day, [1, 2])
  end
  defp process(_) do
    IO.puts """
    Usage:

    To run a day and part:
    advent_of_code --day 1 --part 1

    To run boths parts for a day:
    advent_of_code --day 1

    To run all days:
    advent_of_code --all
    """
  end

  defp run(day, parts) do
    IO.puts "Day #{day}:"
    Enum.each parts, fn part ->
      module = Module.concat("Day#{day}", "Part#{part}")
      input = "input/day#{day}/input"
      result = apply(module, :run, [input])
      IO.puts "  Part #{part}: #{result}"
    end
  end
end
