defmodule Day1.Part1 do
  def run(input) do
    input
    |> File.read!
    |> process_input
    |> compute_distance({:north, 0, 0})
  end

  defp process_input(input) do
    tokens = input |> String.trim |> String.split(", ")
    Enum.map tokens, fn
      "R" <> distance -> {:right, String.to_integer(distance)}
      "L" <> distance -> {:left, String.to_integer(distance)}
    end
  end

  defp compute_distance([], {_face, x, y}), do: abs(x) + abs(y)
  defp compute_distance([head | tail], state) do
    compute_distance(tail, next_state(head, state))
  end

  defp next_state({:right, d}, {:north, x, y}), do: {:east, x + d, y}
  defp next_state({:left, d},  {:north, x, y}), do: {:west, x - d, y}
  defp next_state({:right, d}, {:south, x, y}), do: {:west, x - d, y}
  defp next_state({:left, d},  {:south, x, y}), do: {:east, x + d, y}
  defp next_state({:right, d}, {:east, x, y}),  do: {:south, x, y - d}
  defp next_state({:left, d},  {:east, x, y}),  do: {:north, x, y + d}
  defp next_state({:right, d}, {:west, x, y}),  do: {:north, x, y + d}
  defp next_state({:left, d},  {:west, x, y}),  do: {:south, x, y - d}
end
