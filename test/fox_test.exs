defmodule FoxTest do
  use ExUnit.Case

  test "the truth" do
    IO.puts :random.uniform(64)
    IO.puts :random.uniform(64)
    assert 1 + 1 == 2
  end

  test "Fox.StringExt.to_url" do
    actual = Fox.StringExt.to_url("Breaking! Are 50% of Americans trying to kill you?")
    expected = "breaking-bang-are-50-percent-of-americans-trying-to-kill-you-question"
    assert actual == expected
  end

  test "Fox.StringExt.random" do
    str = Fox.StringExt.random(33)
    str2 = Fox.StringExt.random(25)
    len = String.length(str)
    assert len == 33
    assert String.length(str2) == 25
  end

  test "Fox.StringExt.random error" do
    assert_raise RuntimeError, fn ->
      Fox.StringExt.random(0.22)
    end
  end
end
