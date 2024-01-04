defmodule ExSudoku do
  @moduledoc """
  Documentation for `ExSudoku`.
  """
  import ExSudoku.Helpers

  @digits ~c"123456789"
  @rows ~c"ABCDEFGHI"
  @cols @digits
  @grid ~c"003020600900305001001806400008102900700000008006708200002609500800203009005010300"
  @squares cross(@rows, @cols)

  def run do
    unit_list = get_unit_list()
    units = get_units(unit_list)
    peers = get_peers(units)
    parsed_grid = parse_grid(@grid)

    %{
      squares: @squares,
      unit_list: unit_list,
      units: units,
      peers: peers
    }
  end

  defp get_unit_list do
    first = Enum.map(@cols, &cross(@rows, [&1]))
    second = Enum.map(@rows, &cross([&1], @cols))

    third =
      for rs <- ~w(ABC DEF GHI),
          cs <- ~w(123 456 789),
          do: cross(String.to_charlist(rs), String.to_charlist(cs))

    first ++ second ++ third
  end

  defp get_units(unit_list) do
    @squares
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

  defp parse_grid(grid) do
    values = Enum.map(@squares, &{&1, @digits}) |> Enum.into(%{})

    for {s, d} <- grid_values(@grid) do
      assign(values, s, d)
      # if(d in @digits and not assign(values, s, d), do: false, else: values)
    end
  end

  defp grid_values(grid) do
    Enum.zip_with(grid, @squares, fn c, s ->
      if c in @digits || c in ~c'0.', do: {s, <<c>>}, else: raise("Wrong grid format.")
    end)
    |> Enum.into(%{})
  end

  defp assign(values, s, d) do
    other_values =
      values[s]
      |> to_string()
      |> String.replace(d, "")
      |> to_charlist()

    dbg(other_values)
    false
  end
end
