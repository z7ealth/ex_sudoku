defmodule ExSudokuTest do
  use ExUnit.Case
  doctest ExSudoku

  setup_all do
    data = ExSudoku.run()

    IO.inspect(data, label: "Testing with data")

    {:ok, data: data}
  end

  test "Sudoku squares", context do
    assert length(context[:data].squares) == 81
  end

  test "Sudoku unit_list", context do
    assert length(context[:data].unit_list) == 27
  end

  test "Sudoku unit length", context do
    Enum.each(context[:data].units, fn {_, v} -> assert length(v) == 3 end)
  end

  test "Sudoku peer length", context do
    Enum.each(context[:data].peers, fn {_, v} -> assert length(v) == 20 end)
  end

  test "Sudoku units", context do
    assert context[:data].units["C2"] == [
             ["A2", "B2", "C2", "D2", "E2", "F2", "G2", "H2", "I2"],
             ["C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9"],
             ["A1", "A2", "A3", "B1", "B2", "B3", "C1", "C2", "C3"]
           ]
  end

  test "Sudoku peers", context do
    assert context[:data].peers["C2"] == [
             "A2",
             "B2",
             "D2",
             "E2",
             "F2",
             "G2",
             "H2",
             "I2",
             "C1",
             "C3",
             "C4",
             "C5",
             "C6",
             "C7",
             "C8",
             "C9",
             "A1",
             "A3",
             "B1",
             "B3"
           ]
  end
end
