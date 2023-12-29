defmodule ExSudoku do
  @moduledoc """
  Documentation for `ExSudoku`.
  """

  @digits ~c"123456789"
  @rows ~c"ABCDEFGHI"
  @cols @digits

  def run do
    squares = cross(@rows, @cols)
    unit_list = get_unit_list()
    units = get_units(squares, unit_list)
    peers = get_peers(units)

    %{
      squares: squares,
      unit_list: unit_list,
      units: units,
      peers: peers
    }
  end

  defp cross(a, b), do: for(x <- a, y <- b, do: <<x, y>>)

  defp get_unit_list do
    first = Enum.map(@cols, &cross(@rows, [&1]))
    second = Enum.map(@rows, &cross([&1], @cols))

    third =
      for rs <- ~w(ABC DEF GHI),
          cs <- ~w(123 456 789),
          do: cross(String.to_charlist(rs), String.to_charlist(cs))

    first ++ second ++ third
  end

  defp get_units(squares, unit_list) do
    squares
    |> Enum.map(&{&1, Enum.filter(unit_list, fn unit -> &1 in unit end)})
    |> Enum.into(%{})
  end

  defp get_peers(units) do
    Enum.map(units, fn {k, unit} ->
      unit
      |> List.flatten()
      |> Enum.uniq()
      |> List.delete(k)
      |> (&{k, &1}).()
    end)
    |> Enum.into(%{})
  end
end
