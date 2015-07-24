defmodule FoxTest do
  use ExUnit.Case

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "Fox.StringExt.to_url" do
    actual = Fox.StringExt.to_url("Breaking! Are 50% of Americans trying to kill you?")
    expected = "breaking-bang-are-50-percent-of-americans-trying-to-kill-you-question"
    assert actual == expected
  end
end
