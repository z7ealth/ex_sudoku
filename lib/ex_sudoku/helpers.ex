defmodule ExSudoku.Helpers do
 def cross(a, b), do: for(x <- a, y <- b, do: <<x, y>>)
end
