defmodule FoxTest do
  use ExUnit.Case

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "Fox.StringExt.integer?" do
    assert Fox.StringExt.integer?("12")
    refute Fox.StringExt.integer?("bob")
    assert Fox.StringExt.integer?("0")
    refute Fox.StringExt.integer?("")
  end

  test "Fox.StringExt.float?" do
    assert Fox.StringExt.float?("12.3")
    refute Fox.StringExt.float?("12")
    assert Fox.StringExt.float?("00.21")
    refute Fox.StringExt.float?("asdf a.sdfj 028ij")
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

  # Run the test twice and inspect that the value should be different
  test "Fox.RandomExt.uniform" do
    k = Fox.RandomExt.uniform(99)
    IO.puts k
    assert k
  end

  test "Fox.UriExt.encode_query should encode complex queries" do
    query = [
      dog: "rover", 
      cats: ["mrmittens", "fluffmeister"], 
      mascots: %{ember: "hamster", go: "gopher"}
    ]
    actual = query |> Fox.UriExt.encode_query |> String.replace("%5B", "[") |> String.replace("%5D", "]")
    expected = "dog=rover&cats[]=mrmittens&cats[]=fluffmeister&mascots[ember]=hamster&mascots[go]=gopher"
    assert actual == expected
  end

  test "encode_query should work on maps also" do
    query = %{
      "cat" => "fluffy",
      "dogs" => ["rover", "spot"]
    }
    actual = query |> Fox.UriExt.encode_query |> String.replace("%5B", "[") |> String.replace("%5D", "]")
    expected = "cat=fluffy&dogs[]=rover&dogs[]=spot"
    assert actual == expected
  end

  test "it should handle empty things just fine" do
    q1 = %{}
    q2 = []
    assert Fox.UriExt.encode_query(q1) == ""
    assert Fox.UriExt.encode_query(q2) == ""
  end

  test "Fox.DictExt.shallowify_keys should produce shallow list keys" do
    dict = %{
      dog: "rover", 
      cats: ["mrmittens", "fluffmeister"], 
      mascots: %{ember: "hamster", go: "gopher"}
    }
    actual = dict |> Fox.DictExt.shallowify_keys
    expected = [
      {"cats[]", "mrmittens"},
      {"cats[]", "fluffmeister"},
      {"dog", "rover"},
      {"mascots[ember]", "hamster"},
      {"mascots[go]", "gopher"}
    ]
    assert actual == expected
  end

  test "Fox.UriExt.fmt should work" do
    actual = "customers/:custmer_id/cards/:id/thing/:id" |> Fox.UriExt.fmt({"cus_666", "car_616", "444"})
    expected = "customers/cus_666/cards/car_616/thing/444"
    assert actual == expected
  end

  test "Fox.ParExt.|> should calculate things in parallel" do
    import Kernel, except: [{:|>, 2}]
    import Fox.ParExt, only: [{:|>, 2}]
    plus = fn x -> x + 1 end
    times = fn x -> x * 9 end
    actual = {1,2} |> {plus.(), times.()}
    expected = {2, 18}
    assert actual == expected
  end

  defmodule Somaru do
    defstruct singer: "reol"
  end
  defmodule SomaruView, [do: "dogs"]
  test "Fox.RecordExt.view_for_model should find correct module" do
    model = %Somaru{}
    assert model.singer == "reol"
    actual = model |> Fox.RecordExt.view_for_model
    expected = SomaruView
    assert actual == expected
  end
end
