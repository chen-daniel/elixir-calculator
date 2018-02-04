defmodule Calc do
  @moduledoc """
  Documentation for Calc.
  Run with Calc.main()

  Evaluates arithmetic expressions.
  """

  @doc """
  """

  # Read Eval Print Loop
  def main() do

    input = IO.gets "Please input a valid arithmetic expression: "
    try do
      IO.puts eval(input)
    rescue
      e in RuntimeError -> IO.puts("Invalid expression.")
    end
    main()
  end

  # Evaluates an arithmetic expression from a String to an Integer
  # String -> Integer
  def eval(input) do
    input
    |> String.trim()
    |> String.replace("(", "( ")
    |> String.replace(")", " )")
    |> String.split()
    |> calculate()
    |> Enum.at(0)
    |> Integer.parse()
    |> elem(0)
  end

  # Evaluates a string array representing an arithmetic expression and returns a string array
  # representing the answer.
  # String[] -> String[]
  def calculate(listInput) do
    listInput
    |> replace_parens()
    |> solve_flat()
  end

  # Solves a flat arithmetic expression with no parens
  # String[] -> String[]
  def solve_flat(input) do
    if Enum.count(input) == 1 do
      input
    else
      input
      |> solve_mult_and_div()
      |> solve_add_and_sub()
    end
  end

  # Solves all multiplications and divisions in PEMDAS order from a flat expression
  # String[] -> String[]
  def solve_mult_and_div(input) do
    op_index = Enum.find_index(input, fn x -> x == "*" || x == "/" end)
    case op_index do
      nil -> input
      _ ->
        calculated_value =
          input
          |> operate(op_index, String.to_atom(Enum.at(input, op_index)))

        input_tail =
          input
          |> Enum.split(op_index + 2)
          |> elem(1)

        input
        |> Enum.split(op_index - 1)
        |> elem(0)
        |> Enum.concat(calculated_value)
        |> Enum.concat(input_tail)
        |> solve_mult_and_div()
    end
  end

  # Solves all additions and subtractions in PEMDAS order from a flat expression
  # String[] -> String[]
  def solve_add_and_sub(input) do
    op_index = Enum.find_index(input, fn x -> x == "+" || x == "-" end)
    case op_index do
      nil -> input
      _ ->
        calculated_value =
          input
          |> operate(op_index, String.to_atom(Enum.at(input, op_index)))

        input_tail =
          input
          |> Enum.split(op_index + 2)
          |> elem(1)

        input
        |> Enum.split(op_index - 1)
        |> elem(0)
        |> Enum.concat(calculated_value)
        |> Enum.concat(input_tail)
        |> solve_add_and_sub()
    end
  end

  # Runs a multiplication operation given the index of the operation and an atom representing the operation
  # String[] Integer Atom -> String[]
  def operate(input, op_index, :*) do
    int1 =
      input
      |> Enum.at(op_index - 1)
      |> Integer.parse()
      |> elem(0)

    int2 =
      input
      |> Enum.at(op_index + 1)
      |> Integer.parse()
      |> elem(0)

    [Integer.to_string(int1 * int2)]
  end

  # Runs a division operation given the index of the operation and an atom representing the operation
  # String[] Integer Atom -> String[]
  def operate(input, op_index, :/) do
    int1 =
      input
      |> Enum.at(op_index - 1)
      |> Integer.parse()
      |> elem(0)

    int2 =
      input
      |> Enum.at(op_index + 1)
      |> Integer.parse()
      |> elem(0)

    [Integer.to_string(div(int1, int2))]
  end

  # Runs a addition operation given the index of the operation and an atom representing the operation
  # String[] Integer Atom -> String[]
  def operate(input, op_index, :+) do
    int1 =
      input
      |> Enum.at(op_index - 1)
      |> Integer.parse()
      |> elem(0)

    int2 =
      input
      |> Enum.at(op_index + 1)
      |> Integer.parse()
      |> elem(0)

    [Integer.to_string(int1 + int2)]
  end

  # Runs a subtraction operation given the index of the operation and an atom representing the operation
  # String[] Integer Atom -> String[]
  def operate(input, op_index, :-) do
    int1 =
      input
      |> Enum.at(op_index - 1)
      |> Integer.parse()
      |> elem(0)

    int2 =
      input
      |> Enum.at(op_index + 1)
      |> Integer.parse()
      |> elem(0)

    [Integer.to_string(int1 - int2)]
  end

  # Flattens out the arithmetic expression recursively solving the inner parens
  # String[] -> String[]
  def replace_parens(input) do
    open_paren_index = Enum.find_index(input, fn x -> x == "(" end)
    case open_paren_index do
      nil -> input
      _ ->
        close_paren_index =
          input
          |> Enum.split(open_paren_index + 1)
          |> elem(1)
          |> find_close_paren(open_paren_index + 1, 0)

        calculated_value =
          input
          |> Enum.slice(open_paren_index + 1, close_paren_index - open_paren_index - 1)
          |> calculate()

        input_tail =
          input
          |> Enum.split(close_paren_index + 1)
          |> elem(1)

        input
        |> Enum.split(open_paren_index)
        |> elem(0)
        |> Enum.concat(calculated_value)
        |> Enum.concat(input_tail)
        |> replace_parens()
    end
  end

  # Finds the first lone closing paren in the rest of the list and returns the index
  # String[] Integer Integer -> Integer
  def find_close_paren(input, index, acc) do
    if Enum.empty?(input) do
      exit "Invalid input"
    end

    case Enum.at(input, 0) do
      "(" -> input
      |> Enum.split(1)
      |> elem(1)
      |> find_close_paren(index + 1, acc + 1)

      ")" -> if acc == 0 do
        index
      else
        input
        |> Enum.split(1)
        |> elem(1)
        |> find_close_paren(index + 1, acc - 1)
      end

      _ -> input
      |> Enum.split(1)
      |> elem(1)
      |> find_close_paren(index + 1, acc)

    end
  end
end
