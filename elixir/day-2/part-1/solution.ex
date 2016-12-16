defmodule Day2.Part1.Solution do
  require IEx
  @states %{
    #     U, D, L, R
    1 => {1, 4, 1, 2},
    2 => {2, 5, 1, 3},
    3 => {3, 6, 2, 3},
    4 => {1, 7, 4, 5},
    5 => {2, 8, 4, 6},
    6 => {3, 9, 5, 6},
    7 => {4, 7, 7, 8},
    8 => {5, 8, 7, 9},
    9 => {6, 9, 8, 9}
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
