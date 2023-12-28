defmodule ExSudokuTest do
  use ExUnit.Case
  doctest ExSudoku
  
  @data ExSudoku.run()


  test "Sudoku squares" do
    assert length(@data.squares) == 81
  end

  test "Sudoku unit_list" do
    assert length(@data.unit_list) == 27
  end
end
