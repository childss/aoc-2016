defmodule Day6.Part2 do
  def run(input) do
    input
    |> File.read!
    |> String.split("\n", trim: true)
    |> correct_message
  end

  defp correct_message(messages) do
    messages
    |> Enum.reduce(%{}, &count_letters/2)
    |> Enum.map_join("", fn {_k, position_counts} ->
      {l, _} = Enum.min_by(position_counts, fn {_k, v} -> v end)
      l
    end)
  end

  defp count_letters(message, counts) do
    message
    |> String.codepoints
    |> Enum.with_index
    |> Enum.reduce(counts, fn {letter, position}, acc ->
      position_counts =
        acc
        |> Map.get(position, %{})
        |> Map.update(letter, 1, &(&1 + 1))
      Map.put(acc, position, position_counts)
    end)
  end
end
