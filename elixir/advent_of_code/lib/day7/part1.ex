defmodule Day7.Part1 do
  require Integer

  def run(input) do
    input
    |> File.read!
    |> String.split("\n", trim: true)
    |> Enum.count(&supports_tls?/1)
  end

  defp supports_tls?(ip) do
    {sequences, hypernets} =
      ip
      |> String.split(["[", "]"])
      |> Enum.with_index
      |> Enum.partition(fn {_seq, i} -> Integer.is_even(i) end)

    Enum.any?(sequences, &has_abba?/1) && not(Enum.any?(hypernets, &has_abba?/1))
  end

  def has_abba?({seq, _}), do: has_abba?(String.codepoints(seq))
  def has_abba?([a1, b1, b2, a2 | tail]) do
    if a1 == a2 && b1 == b2 && a1 != b1 do
      true
    else
      has_abba?([b1, b2, a2 | tail])
    end
  end
  def has_abba?([]), do: false
  def has_abba?([_ | tail]), do: has_abba?(tail)
end
