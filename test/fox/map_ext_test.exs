defmodule Fox.MapExtTest do
  import Fox.MapExt
  use ExUnit.Case

  test "present_update" do
    assert %{dog: 2, cat: 2} == %{dog: 1, cat: 2} |> present_update(:dog, &(&1 + 1))
    assert %{dog: 1, cat: 3} == %{dog: 1, cat: 3} |> present_update(:serenade, &(&1 * &1))

    assert %{} == %{} |> present_update(:xxx, &throw/1)
  end

  test "present_put" do
    assert %{dog: 1} == %{dog: 1} |> present_put(:cat, %{})
    assert %{dog: 1} == %{dog: 1} |> present_put(:cat, nil)
    assert %{dog: 1} == %{dog: 1} |> present_put(:cat, "")
    assert %{dog: 1, cat: 1} == %{dog: 1} |> present_put(:cat, 1)
  end

  test "value_map" do
    assert %{dog: 3, cat: 4} == %{dog: 1, cat: 2} |> value_map(&(&1 + 2))
    assert %{} == %{} |> value_map(&(&1 + 2))
  end
end