defmodule Day4.Part2 do
  @line_regex ~r/([a-z\-]+)-(\d{3})\[([a-z]{5})\]/
  @alphabet String.codepoints("abcdefghijklmnopqrstuvwxyz")
  @alphabet_len Enum.count(@alphabet)

  def run(input) do
    input
    |> File.read!
    |> parse_input
    |> find_northpole_storage
  end

  defp parse_input(data) do
    for line <- String.split(data, "\n", trim: true),
        parsed = Regex.run(@line_regex, line, capture: :all_but_first),
        do: List.to_tuple(parsed)
  end

  defp find_northpole_storage(rooms) do
    rooms
    |> Enum.filter(&real_room?/1)
    |> Enum.find(fn room ->
      decode_room(room) == "northpole object storage"
    end)
    |> sector_id
  end

  defp decode_room({name, sector_id, _}) do
    name
    |> String.codepoints
    |> decode_name(String.to_integer(sector_id))
    |> Enum.join("")
  end

  defp decode_name([], _sector_id), do: []
  defp decode_name(["-" | name], sector_id), do: [" " | decode_name(name, sector_id)]
  defp decode_name([letter | name], sector_id) do
    index = Enum.find_index(@alphabet, fn x -> x == letter end)
    next = Enum.at(@alphabet, rem(index + sector_id, @alphabet_len))
    [next | decode_name(name, sector_id)]
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
