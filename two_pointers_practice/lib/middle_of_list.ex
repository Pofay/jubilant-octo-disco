defmodule TwoPointersPractice.MiddleOfList do

  def find_middle([head | tail]) do
    do_find_middle(head, head, tail)
  end

  def do_find_middle(slow, _fast, []) do
    slow
  end

  def do_find_middle(slow, fast, [head | tail]) do
    0
  end
end
