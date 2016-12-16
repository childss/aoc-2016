defmodule Day1.Part2 do
  def run(input) do
    input
    |> File.read!
    |> process_input
    |> walk_path({:north, 0, 0}, MapSet.new)
    |> compute_distance
  end

  defp process_input(input) do
    tokens = input |> String.trim |> String.split(", ")
    Enum.map tokens, fn
      "R" <> distance -> {:right, String.to_integer(distance)}
      "L" <> distance -> {:left, String.to_integer(distance)}
    end
  end

  defp walk_path([], {_face, x, y}, _visited), do: {x, y}
  defp walk_path([head | tail], state, visited) do
    next = next_state(head, state)
    intermediate = intermediate_states(state, next)
    if MapSet.disjoint?(visited, intermediate) do
      walk_path(tail, next, MapSet.union(visited, intermediate))
    else
      visited
      |> MapSet.intersection(intermediate)
      |> MapSet.to_list
      |> List.first
    end
  end

  defp intermediate_states({_, x1, y}, {_, x2, y}) do
    states = Enum.reduce x1..x2, MapSet.new, fn x, acc ->
      MapSet.put(acc, {x, y})
    end
    states |> MapSet.delete({x1, y})
  end
  defp intermediate_states({_, x, y1}, {_, x, y2}) do
    states = Enum.reduce y1..y2, MapSet.new, fn y, acc ->
      MapSet.put(acc, {x, y})
    end
    states |> MapSet.delete({x, y1})
  end

  defp next_state({:right, d}, {:north, x, y}), do: {:east, x + d, y}
  defp next_state({:left, d},  {:north, x, y}), do: {:west, x - d, y}
  defp next_state({:right, d}, {:south, x, y}), do: {:west, x - d, y}
  defp next_state({:left, d},  {:south, x, y}), do: {:east, x + d, y}
  defp next_state({:right, d}, {:east, x, y}),  do: {:south, x, y - d}
  defp next_state({:left, d},  {:east, x, y}),  do: {:north, x, y + d}
  defp next_state({:right, d}, {:west, x, y}),  do: {:north, x, y + d}
  defp next_state({:left, d},  {:west, x, y}),  do: {:south, x, y - d}

  defp compute_distance({x, y}), do: abs(x) + abs(y)
end
