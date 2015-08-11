defmodule Fox.UriExt do
  def encode_query([]), do: ""
  def encode_query(nil), do: ""
  def encode_query(params) do
    params
    |> Fox.DictExt.shallowify_keys
    |> URI.encode_query
  end

  def fmt(uri, {}), do: uri
  def fmt(uri, tuple) do
    head = elem tuple, 0
    rest = Tuple.delete_at tuple, 0
    uri = uri |> String.replace(~r/:[a-zA-Z0-9_]+/, head, global: false)
    fmt(uri, rest)
  end
end