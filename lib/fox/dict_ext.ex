defmodule Fox.DictExt do
  @doc """
  Takes a Dict and drops every key which has a blank value
  
  ### Examples
      %{dog: nil, cat: 4} |> reject_blank_keys
      # %{cat: 4}
  """
  @spec reject_blank_keys(Dict.t) :: Dict.t
  def reject_blank_keys(dict) do
    bad_keys = Dict.keys(dict) 
    |> Enum.filter(fn key -> is_blank(Dict.get dict, key) end)
    Dict.drop dict, bad_keys
  end

  def is_blank(nil), do: true
  def is_blank(""), do: true
  def is_blank(_), do: false

  @doc """
  Maps over just the value of your map while keeping
  all the keys the same

  ### Examples
      %{dog: 1, cat: 2} |> value_map(&(&1 + 2))
      # %{dog: 3, cat: 4}
  """
  @spec value_map(Dict.t, (any -> any)) :: Dict.t
  def value_map(dict, f) do
    dict
    |> Dict.keys
    |> Enum.reduce(dict, fn key, dict -> dict |> Dict.update!(key, f) end)
  end

  @doc """
  Maps over the keys of a dict while leaving the values alone

  ### Examples
      %{"dog_food" => 3} |> key_map(&StringExt.camelize/1)
      # %{"DogFood" => 3}
  """
  @spec key_map(Dict.t, (any -> any)) :: Dict.t
  def key_map(dict, f) do
    dict
    |> Dict.keys
    |> Enum.reduce(dict, &key_map_transfer(&1, &2, f))
  end
  defp key_map_transfer(key, dict, f) do
    {value, dict} = dict |> Dict.pop(key)
    dict |> Dict.put(f.(key), value)
  end

  @doc """
  Takes a possibly deeply nested dict, and "unnests" it

  ### Examples
      %{"dog" => %{"cat" => "rover"}} |> shallowify_keys
      # [{"dog[cat]", "rover"}]
  """
  @spec shallowify_keys(Dict.t) :: List.t
  def shallowify_keys(map) when is_map(map) do 
    shallowify_keys_core(map)
  end
  def shallowify_keys(list) when is_list(list) do 
    shallowify_keys_core(list)
  end
  def shallowify_keys(dict) do
    dict
    |> Dict.to_list
    |> shallowify_keys
  end

  defp shallowify_keys_core(mappable, prefix\\"") do
    mappable
    |> Enum.map(&shallowify_pair(&1, prefix))
    |> List.flatten
  end

  defp shallowify_pair({key, map}, prefix) when is_map(map) do
    shallowify_keys_core(map, prefix <> "#{key}[:key]")
  end

  defp shallowify_pair({key, list}, prefix) when is_list(list) do
    shallowify_keys_core(list, prefix <> "#{key}[]")
  end

  defp shallowify_pair({key, value}, prefix) do
    prefix 
    |> String.replace(~r/(:key|$)/, "#{key}", global: false)
    |> tup(value)
  end

  defp shallowify_pair(value, prefix) do
    {prefix, value}
  end

  defp tup(key, value), do: {key, value}
end