defmodule ExSudoku.Helpers do
  @doc """
  Returns ab for each char a and char b.
  """
  @spec cross(charlist(), charlist()) :: char()
  def cross(a, b), do: for(x <- a, y <- b, do: <<x, y>>)

  def merge_lists(first, second, third), do: first ++ second ++ third

  def delete_value(values, s, d),
    do:
      values[s]
      |> to_string()
      |> String.replace(d, "")
      |> to_charlist()
end
