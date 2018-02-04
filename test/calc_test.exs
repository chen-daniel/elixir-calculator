defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "test_eval" do
    assert Calc.eval("3 + 4") == 7
    assert Calc.eval("3 * 4") == 12
    assert Calc.eval("20 / 4") == 5
    assert Calc.eval("50 - 30") == 20
    assert Calc.eval("10 - 20") == -10
    assert Calc.eval("(3 + 4 * (6 / 3)) * (2 * 5)") == 110
    assert Calc.eval("(2 * 5)") == 10
    assert Calc.eval("((5))") == 5
  end

  test "test_calculate" do
    assert Calc.calculate(["3", "+", "4"]) == ["7"]
    assert Calc.calculate(["(", "3", "+", "4", "*", "(", "6", "/", "3", ")", ")", "*", "(", "2", "*", "5", ")"]) == ["110"]
    assert Calc.calculate(["5"]) == ["5"]
  end

  test "test_solve_flat" do
    assert Calc.solve_flat(["3", "+", "4"]) == ["7"]
    assert Calc.solve_flat(["3", "+", "4", "*", "5"]) == ["23"]
    assert Calc.solve_flat(["5"]) == ["5"]
  end

  test "test_solve_mult_and_div" do
    assert Calc.solve_mult_and_div(["3", "+", "4"]) == ["3", "+", "4"]
    assert Calc.solve_mult_and_div(["3", "+", "4", "*", "5"]) == ["3", "+", "20"]
    assert Calc.solve_mult_and_div(["3"]) == ["3"]
  end

  test "test_solve_add_and_sub" do
    assert Calc.solve_add_and_sub(["3", "+", "4"]) == ["7"]
    assert Calc.solve_add_and_sub(["20", "-", "5", "+", "10"]) == ["25"]
    assert Calc.solve_add_and_sub(["5"]) == ["5"]
  end

  test "test_operate" do
    assert Calc.operate(["3", "+", "4"], 1, :+) == ["7"]
    assert Calc.operate(["3", "*", "4"], 1, :*) == ["12"]
    assert Calc.operate(["20", "/", "5"], 1, :/) == ["4"]
    assert Calc.operate(["5", "-", "2"], 1, :-) == ["3"]
    assert Calc.operate(["5", "+", "4", "*", "3"], 3, :*) == ["12"]
  end

  test "replace_parens" do
    assert Calc.replace_parens(["(", "2", "*", "5", ")"]) == ["10"]
    assert Calc.replace_parens(["5", "*", "(", "5", "+", "2", ")"]) == ["5", "*", "7"]
    assert Calc.replace_parens(["(", "(", "5", ")", ")"]) == ["5"]
  end

  test "find_close_paren" do
    assert Calc.find_close_paren(["5", ")"], 1, 0) == 2
    assert Calc.find_close_paren(["(", "5", ")", ")"], 1, 0) == 4
    assert Calc.find_close_paren(["(", "3", "*", "4", "+", "(", "5", "-", "2", ")", ")", ")", "*", "5"], 5, 0) == 16
  end

end
