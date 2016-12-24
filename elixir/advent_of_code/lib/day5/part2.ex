defmodule Day5.Part2 do
  @digit ~r/\d/

  def run(input) do
    input
    |> File.read!
    |> String.trim
    |> compute_password(0, %{})
  end

  def compute_password(door, integer, password) do
    if Enum.count(password) == 8 do
      format_password(password)
    else
      hashed = hash(door, integer)
      if String.starts_with?(hashed, "00000") do
        compute_password(door, integer + 1, update_password(password, hashed))
      else
        compute_password(door, integer + 1, password)
      end
    end
  end

  defp update_password(password, hashed) do
    position = String.at(hashed, 5)
    if Regex.match?(@digit, position) && String.to_integer(position) <= 7 do
      Map.put_new(password, position, String.at(hashed, 6))
    else
      password
    end
  end

  defp hash(door, integer) do
    :crypto.hash(:md5, "#{door}#{integer}") |> Base.encode16
  end

  def format_password(password) do
    password
    |> Enum.to_list
    |> Enum.sort(fn {k1, _}, {k2, _} -> k1 < k2 end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.join("")
    |> String.downcase
  end
end
