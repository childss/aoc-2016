defmodule Day7.Part2 do
  require Integer

  def run(input) do
    input
    |> File.read!
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_nets/1)
    |> Enum.count(&supports_ssl?/1)
  end

  defp parse_nets(line) do
    parse_supernet(String.codepoints(line), [], [], [])
  end

  defp parse_supernet([], token, supernets, hypernets) do
    {[to_s(token) | supernets], hypernets}
  end
  defp parse_supernet(["[" | tail], token, supernets, hypernets) do
    parse_hypernet(tail, [], [to_s(token) | supernets], hypernets)
  end
  defp parse_supernet([c | tail], token, supernets, hypernets) do
    parse_supernet(tail, [c | token], supernets, hypernets)
  end
  
  defp parse_hypernet([], token, supernets, hypernets) do
    {supernets, [to_s(token) | hypernets]}
  end
  defp parse_hypernet(["]" | tail], token, supernets, hypernets) do
    parse_supernet(tail, [], supernets, [to_s(token) | hypernets])
  end
  defp parse_hypernet([c | tail], token, supernets, hypernets) do
    parse_hypernet(tail, [c | token], supernets, hypernets)
  end

  defp to_s(token) do
    token |> Enum.reverse |> Enum.join("")
  end

  defp supports_ssl?({supernets, hypernets}) do
    supernets
    |> Enum.flat_map(&collect_aba(String.codepoints(&1), []))
    |> Enum.any?(fn aba ->
      Enum.any?(hypernets, fn h -> String.contains?(h, aba_to_bab(aba)) end)
    end)
  end

  defp collect_aba([], results), do: results
  defp collect_aba([a1, b1, a2 | tail], results) do
    if a1 == a2 && a1 != b1 do
      collect_aba([b1, a2 | tail], ["#{a1}#{b1}#{a2}" | results])
    else
      collect_aba([b1, a2 | tail], results)
    end
  end
  defp collect_aba([_ | tail], results), do: collect_aba(tail, results)

  defp aba_to_bab(aba) do
    [a, b, _] = String.codepoints(aba)
    "#{b}#{a}#{b}"
  end
end
