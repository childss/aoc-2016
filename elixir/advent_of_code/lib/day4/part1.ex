defmodule Day4.Part1 do
  @line_regex ~r/([a-z\-]+)-(\d{3})\[([a-z]{5})\]/

  def run(input) do
    input
    |> File.read!
    |> parse_input
    |> sum_real_sectors
  end

  defp parse_input(data) do
    for line <- String.split(data, "\n", trim: true),
        parsed = Regex.run(@line_regex, line, capture: :all_but_first),
        do: List.to_tuple(parsed)
  end

  defp sum_real_sectors(rooms) do
    rooms
    |> Enum.filter_map(&real_room?/1, &sector_id/1)
    |> Enum.sum
  end

  defp real_room?({name, _sector_id, checksum}) do
    name
    |> count_letters
    |> validate_checksum(String.codepoints(checksum))
  end

  defp count_letters(name) do
    name
    |> String.replace("-", "")
    |> String.codepoints
    |> Enum.map(fn x -> %{ x => 1 } end)
    |> Enum.reduce(fn x, acc -> Map.merge(x, acc, fn _k, v1, v2 -> v1 + v2 end) end)
    |> Enum.to_list
    |> Enum.sort(&compare_letter_count/2)
  end

  defp validate_checksum(_, []), do: true
  defp validate_checksum([{current, _} | counts], [check | checksum]) do
    (current == check) && validate_checksum(counts, checksum)
  end

  defp sector_id({_, sector, _}), do: String.to_integer(sector)

  defp compare_letter_count({l1, c1}, {l2, c2}) do
    c1 > c2 || (c1 == c2 && l1 < l2)
  end
end
