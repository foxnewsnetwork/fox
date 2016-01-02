defmodule Fox.ListExtTest do
  use ExUnit.Case
  alias Fox.ListExt
  
  test "head" do
    assert [1,2,3] |> ListExt.head == [1,2]
    assert [] |> ListExt.head == []
  end

  test "tail" do
    assert [1,2,3] |> ListExt.tail == [2,3]
    assert [] |> ListExt.tail == []
  end
end