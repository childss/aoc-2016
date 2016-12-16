defmodule Day3.Part1 do
  def run(input) do
    input
    |> File.read!
    |> parse_input
    |> count_triangles
  end

  defp parse_input(input) do
    for line <- String.split(input, "\n", trim: true),
        sides = String.split(line, " ", trim: true),
        do: Enum.map(sides, &String.to_integer/1)
  end

  defp count_triangles(candidates) do
    Enum.count(candidates, &is_triangle?/1)
  end

  defp is_triangle?(candidate) do
    candidate
    |> permute
    |> Enum.all?(fn [a, b, c] -> a + b > c end)
  end

  defp permute([]), do: [[]]
  defp permute(list) do
    for x <- list, y <- permute(list -- [x]), do: [x|y]
  end
end
