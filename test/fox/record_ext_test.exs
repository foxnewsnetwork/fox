defmodule Fox.RecordExtTest do
  use ExUnit.Case
  alias Fox.RecordExt

  defmodule Somaru do
    defstruct singer: "reol"
  end
  defmodule SomaruView, [do: "dogs"]
  defmodule SomaruController, [do: "dogs"]
  test "Fox.RecordExt.view_for_model should find correct module" do
    model = %Somaru{}
    assert model.singer == "reol"
    actual = model |> RecordExt.view_for_model
    expected = SomaruView
    assert actual == expected
  end

  test "controller_for_model do" do
    model = %Somaru{}
    actual = model |> RecordExt.controller_for_model
    expected = SomaruController
    assert actual == expected
  end

  test "infer_collection_key" do
    expected = :somarus
    model = %Somaru{}
    actual = model |> RecordExt.infer_collection_key
    assert actual == expected
  end

  test "infer_model_key" do
    expected = :somaru
    model = %Somaru{}
    actual = model |> RecordExt.infer_model_key
    assert actual == expected
  end
end