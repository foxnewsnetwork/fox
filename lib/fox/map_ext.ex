defmodule Fox.MapExt do
  @moduledoc """
  Utility functions for common extension to maps
  """

  @doc """
  Runs the update function if and only if the map already
  has the given key.

  ### Examples
      %{dog: 1, cat: 2} |> present_update(:dog, &(&1 + 1))
      # %{dog: 2, cat: 2}

      %{dog: 1, cat: 3} |> present_update(:serenade, &(&1 * &1))
      # %{dog: 1, cat: 3}
  """
  @spec present_update(Map.t, Map.key, (any -> any)) :: Map.t
  def present_update(map, key, update) do
    if map |> Map.has_key?(key) do
      map |> Map.update!(key, update)
    else
      map
    end
  end

  @doc """
  Puts the given value to map if and only if the value
  isn't one of the following: `nil`, `""`, `%{}`

  ### Examples
      %{dog: 1} |> present_put(:cat, %{})
      %{dog: 1}

      %{dog: 1} |> present_put(:cat, 1)
      %{dog: 1, cat: 1}
  """
  @spec present_put(Map.t, Map.key, any) :: Map.t
  def present_put(map, key, value) do
    if value == %{} || Fox.DictExt.is_blank(value) do
      map
    else
      map |> Map.put(key, value)
    end
  end

  @doc """
  Maps over just the value of your map while keeping
  all the keys the same

  ### Examples
      %{dog: 1, cat: 2} |> value_map(&(&1 + 2))
      # %{dog: 3, cat: 4}
  """
  @spec value_map(Map.t, (any -> any)) :: Map.t
  def value_map(map, f) do
    map 
    |> Map.keys
    |> Enum.reduce(map, fn key, map -> map |> Map.update!(key, f) end)
  end
end