defmodule Day5.Part1 do
  def run(input) do
    input
    |> File.read!
    |> String.trim
    |> compute_password
  end

  defp compute_password(door) do
    infinite_seq
    |> Stream.map(&hash(door, &1))
    |> Stream.filter(&String.starts_with?(&1, "00000"))
    |> Stream.take(8)
    |> Enum.map(&String.at(&1, 5))
    |> Enum.join("")
    |> String.downcase
  end

  defp hash(door, integer) do
    :crypto.hash(:md5, "#{door}#{integer}") |> Base.encode16
  end

  defp infinite_seq, do: Stream.unfold(0, fn n -> {n, n + 1} end)
end
