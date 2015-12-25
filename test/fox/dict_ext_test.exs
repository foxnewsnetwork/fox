defmodule Fox.DictExtTest do
  use ExUnit.Case
  alias Fox.DictExt
  alias Fox.StringExt
  test "Fox.DictExt.shallowify_keys should produce shallow list keys" do
    dict = %{
      dog: "rover", 
      cats: ["mrmittens", "fluffmeister"], 
      mascots: %{ember: "hamster", go: "gopher"}
    }
    actual = dict |> DictExt.shallowify_keys
    expected = [
      {"cats[]", "mrmittens"},
      {"cats[]", "fluffmeister"},
      {"dog", "rover"},
      {"mascots[ember]", "hamster"},
      {"mascots[go]", "gopher"}
    ]
    assert actual == expected
  end

  test "value_map" do
    assert %{dog: 3, cat: 4} == %{dog: 1, cat: 2} |> DictExt.value_map(&(&1 + 2))
    assert %{} == %{} |> DictExt.value_map(&(&1 + 2))
  end

  test "key_map" do
    actual = %{"dog_food" => 3, "apple_bees" => "44"} |> DictExt.key_map(&StringExt.camelize/1)
    assert %{"DogFood" => 3, "AppleBees" => "44"} == actual
  end
end