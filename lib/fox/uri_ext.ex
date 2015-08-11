defmodule Fox.UriExt do
  def encode_query([]), do: ""
  def encode_query(nil), do: ""
  def encode_query(params) do
    params
    |> Fox.DictExt.shallowify_keys
    |> URI.encode_query
  end

end