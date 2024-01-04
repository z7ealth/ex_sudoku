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

  @first for c <- @cols, do: cross(@rows, c)

  @second for r <- @rows, do: cross(r, @cols)

  @third for rs <- ~w(ABC DEF GHI),
             cs <- ~w(123 456 789),
             do: cross(String.to_charlist(rs), String.to_charlist(cs))

  @unit_list merge_lists(@first, @second, @third)

  @units @squares
         |> Enum.map(&{&1, Enum.filter(@unit_list, fn unit -> &1 in unit end)})
         |> Enum.into(%{})

  @peers Enum.map(@units, fn {k, unit} ->
           unit
           |> List.flatten()
           |> Enum.uniq()
           |> List.delete(k)
           |> (&{k, &1}).()
         end)
         |> Enum.into(%{})

  @grid_error "Wrong grid format."

  def run do
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

  defp parse_grid(grid) do
    values = Enum.map(@squares, &{&1, @digits}) |> Enum.into(%{})

    for {s, d} <- grid_values(@grid) do
      assign(values, s, d)
      # if(d in @digits and not assign(values, s, d), do: false, else: values)
    end
  end

  defp grid_values(grid) do
    Enum.zip_with(grid, @squares, fn c, s ->
      if c in @digits || c in ~c'0.', do: {s, <<c>>}, else: raise(@grid_error)
    end)
    |> Enum.into(%{})
  end

  defp assign(values, s, d) do
    other_values = delete_value(values, s, d)

    if Enum.all?(other_values, &eliminate(values, s, &1)), do: values, else: false

    defp eliminate(values, s, d) when d not in values[s], do: values

    defp eliminate(values, s, d) do
      values_s = eliminate(values, s, d)

      cond do
        length(values_s) == 0 ->
          false

        length(values_s) == 1 ->
          d2 = values_s
          if Enum.all?(other_values, &eliminate(values, &1, d2)), do: values, else: false
      end
    end
  end
end
