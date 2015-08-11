defmodule Fox.UriExt do
  def encode_query(%{}), do: ""
  def encode_query([]), do: ""
  def encode_query(nil), do: ""
  def encode_query(params) do
    params
    |> shallowify_keys
    |> URI.encode_query
  end

  defp shallowify_keys(params, prefix\\"") do
    params
    |> Enum.map(&shallowify_pair(&1, prefix))
    |> List.flatten
  end

  defp shallowify_pair({key, map}, prefix) when is_map(map) do
    shallowify_keys(map, prefix <> "#{key}[:key]")
  end

  defp shallowify_pair({key, list}, prefix) when is_list(list) do
    shallowify_keys(list, prefix <> "#{key}[]")
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