defmodule Fox.EnumExtTest do
  import Fox.EnumExt
  use ExUnit.Case

  test "oxford_join" do
    assert oxford_join(["shoes", "ships", "sealing-wax"]) ==
      "shoes, ships, and sealing-wax"

    assert oxford_join(["alice"]) == "alice"

    assert oxford_join([]) == ""

    assert oxford_join(["cabbage", "kings"]) == "cabbage and kings"

    assert oxford_join(["rails", "phoenix", "laraval", "express"], ", ", " or ") ==
      "rails, phoenix, laraval, or express"
  end
end