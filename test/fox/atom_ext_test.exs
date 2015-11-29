defmodule Fox.AtomExtTest do
  use ExUnit.Case
  import Fox.AtomExt

  defmodule Fox.AtomExtTest.Apple, do: []
  defmodule Fox.AtomExtTest.DonkeyPunch, do: []
  defmodule Fox.AtomExtTest.AppleController, do: []
  defmodule Fox.AtomExtTest.DonkeyPunchController, do: []
  defmodule Fox.AtomExtTest.AppleView, do: []
  defmodule Fox.AtomExtTest.DonkeyPunchView, do: []

  test "infer_model_module" do
    assert Fox.AtomExtTest.AppleController |> infer_model_module == Fox.AtomExtTest.Apple
    assert Fox.AtomExtTest.DonkeyPunchController |> infer_model_module == Fox.AtomExtTest.DonkeyPunch
    assert Fox.AtomExtTest.AppleView |> infer_model_module == Fox.AtomExtTest.Apple
    assert Fox.AtomExtTest.DonkeyPunchView |> infer_model_module == Fox.AtomExtTest.DonkeyPunch
    assert Fox.AtomExtTest.Apple |> infer_model_module == Fox.AtomExtTest.Apple
    assert Fox.AtomExtTest.DonkeyPunch |> infer_model_module == Fox.AtomExtTest.DonkeyPunch
  end 
  
  test "infer_model_key" do
    assert Fox.AtomExtTest.AppleController |> infer_model_key == :apple
    assert Fox.AtomExtTest.DonkeyPunchController |> infer_model_key == :donkey_punch
    assert Fox.AtomExtTest.AppleView |> infer_model_key == :apple
    assert Fox.AtomExtTest.DonkeyPunchView |> infer_model_key == :donkey_punch
    assert Fox.AtomExtTest.Apple |> infer_model_key == :apple
    assert Fox.AtomExtTest.DonkeyPunch |> infer_model_key == :donkey_punch
  end

  test "infer_collection_key" do
    assert Fox.AtomExtTest.AppleController |> infer_collection_key == :apples
    assert Fox.AtomExtTest.DonkeyPunchController |> infer_collection_key == :donkey_punches
    assert Fox.AtomExtTest.AppleView |> infer_collection_key == :apples
    assert Fox.AtomExtTest.DonkeyPunchView |> infer_collection_key == :donkey_punches
    assert Fox.AtomExtTest.Apple |> infer_collection_key == :apples
    assert Fox.AtomExtTest.DonkeyPunch |> infer_collection_key == :donkey_punches
  end
end