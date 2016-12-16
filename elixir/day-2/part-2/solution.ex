defmodule Day2.Part2.Solution do
  require IEx
  @states %{
    #       U, D, L, R
    1   => {1, 3, 1, 1},
    2   => {2, 6, 2, 3},
    3   => {1, 7, 2, 4},
    4   => {4, 8, 3, 4},
    5   => {5, 5, 5, 6},
    6   => {2, "A", 5, 7},
    7   => {3, "B", 6, 8},
    8   => {4, "C", 7, 9},
    9   => {9, 9, 8, 9},
    "A" => {6, "A", "A", "B"},
    "B" => {7, "D", "A", "C"},
    "C" => {8, "C", "B", "C"},
    "D" => {"B", "D", "D", "D"}
  }

  def run(input) do
    input
    |> File.read!
    |> process_input
    |> compute_digits(5)
    |> Enum.join("")
  end

  defp process_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  defp compute_digits([], _digit), do: []
  defp compute_digits([line | tail], digit) do
    next_digit = Enum.reduce(line, digit, &next(&1, @states[&2]))
    [next_digit | compute_digits(tail, next_digit)]
  end

  defp next("U", {up, _, _, _}), do: up
  defp next("D", {_, down, _, _}), do: down
  defp next("L", {_, _, left, _}), do: left
  defp next("R", {_, _, _, right}), do: right
end
