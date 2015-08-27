defmodule Fox.StringExtTest do
  import Fox.StringExt
  use ExUnit.Case

  test "camelize" do
    assert "under_scored" |> camelize == "UnderScored"
    assert "acronym_hiv" |> camelize == "AcronymHiv"
    assert "sakidasu kasa no mure ni" |> camelize == "Sakidasu kasa no mure ni"
    assert "my_app/module/sub_module" |> camelize == "MyApp.Module.SubModule"
  end

  test "underscore" do
    assert "CamelCase" |> underscore == "camel_case"
    assert "AcronymHIV" |> underscore == "acronym_hiv"
    assert "dasher-ized" |> underscore == "dasher_ized"
    assert "regular words" |> underscore == "regular words"
    assert "MyApp.Module.SubModule" |> underscore == "my_app/module/sub_module"
  end

  test "singularize" do
    assert singularize("dogs") == "dog"
    assert singularize("dog") == "dog"
    assert singularize("sheep") == "sheep"
    assert singularize("sexes") == "sex"
    assert singularize("octopi") == "octopus"
    assert singularize("君の翔ぶ空") == "君の翔"
    assert singularize("多く染") == "染"
    assert singularize("染") == "染"
    assert singularize("doge") == "doge"
    assert singularize("child") == "child"
    assert singularize("children") == "child"
    assert singularize("App.Stupid.Children") == "App.Stupid.Child"
    assert singularize("App.Stupid.Child") == "App.Stupid.Child"
    assert singularize("BadEquipment") == "BadEquipment"
  end

  test "pluralize" do
    assert pluralize("dogs") == "dogs"
    assert pluralize("dog") == "dogs"
    assert pluralize("sheep") == "sheep"
    assert pluralize("sex") == "sexes"
    assert pluralize("octopi") == "octopi"
    assert pluralize("octopus") == "octopi"
    assert pluralize("黒") == "黒猫"
    assert pluralize("染") == "多く染"
    assert pluralize("多く染") == "多く染"
    assert pluralize("doge") == "doge"
    assert pluralize("child") == "children"
    assert pluralize("children") == "children"
    assert pluralize("App.Insufferable.Woman") == "App.Insufferable.Women"
    assert pluralize("App.Insufferable.Women") == "App.Insufferable.Women"
    assert pluralize("BadEquipment") == "BadEquipment"
  end

  test "consume" do
    {:ok, actual} = "Apiv3.AppleController" |> consume("Apiv3.")
    assert actual == "AppleController"

    {:error, error} = "Departures ~あなたにおくるアイの歌~" |> consume("egoist")
    assert error == "expected 'e' to equal 'D' in 'Departures ~あなたにおくるアイの歌~'"
  end

  test "reverse_consume" do
    {:ok, actual} = "Apiv3.AppleController" |> reverse_consume("Controller")
    assert actual == "Apiv3.Apple"

    {:error, error} = "Departures ~あなたにおくるアイの歌" |> reverse_consume("egoist")
    assert error == "expected 't' to equal '歌' in 'Departures ~あなたにおくるアイの歌'"
  end

  test "integer?" do
    assert integer?("12")
    refute integer?("bob")
    assert integer?("0")
    refute integer?("")
  end

  test "float?" do
    assert float?("12.3")
    refute float?("12")
    assert float?("00.21")
    refute float?("asdf a.sdfj 028ij")
  end

  test "to_url" do
    actual = to_url("Breaking! Are 50% of Americans trying to kill you?")
    expected = "breaking-bang-are-50-percent-of-americans-trying-to-kill-you-question"
    assert actual == expected
  end

  test "random" do
    str = random(33)
    str2 = random(25)
    len = String.length(str)
    assert len == 33
    assert String.length(str2) == 25
  end

  test "random error" do
    assert_raise RuntimeError, fn ->
      random(0.22)
    end
  end
end