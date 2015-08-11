defmodule Fox.DictExt do
  def reject_blank_keys(dict) do
    bad_keys = Dict.keys(dict) 
    |> Enum.filter(fn key -> is_blank(Dict.get dict, key) end)
    Dict.drop dict, bad_keys
  end

  def is_blank(nil), do: true
  def is_blank(""), do: true
  def is_blank(_), do: false

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