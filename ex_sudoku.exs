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
  end

  defp cross(a, b), do: for(x <- a, y <- b, do: <<x, y>>)

  defp get_unit_list do
    first = for c <- @cols, do: cross(@rows, [c])
    second = for r <- @rows, do: cross([r], @cols)

    third =
      for rs <- ~w(ABC DEF GHI),
          cs <- ~w(123 456 789),
          do: cross(String.to_charlist(rs), String.to_charlist(cs))

    first ++ second ++ third
  end

  defp get_units(squares, unit_list),
    do: for(s <- squares, into: %{}, do: {s, Enum.filter(unit_list, fn u -> s in u end)})

  defp get_peers(squares, unit_list),
    do: for(s <- squares, into: %{}, do: {s, Enum.filter(unit_list, fn u -> s in u end)})
end
