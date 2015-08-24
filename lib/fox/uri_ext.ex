defmodule Fox.UriExt do
  @doc """
  just like `URI.encode_query/1`, except it also encodes embedded lists and maps

  ## Examples
    query = [
      dog: "rover", 
      cats: ["mrmittens", "fluffmeister"], 
      mascots: %{ember: "hamster", go: "gopher"}
    ] 
    query |> encode_query
    # dog=rover&cats[]=mrmittens&cats[]=fluffmeister&mascots[ember]=hamster&mascots[go]=gopher
  """
  def encode_query([]), do: ""
  def encode_query(nil), do: ""
  def encode_query(params) do
    params
    |> Fox.DictExt.shallowify_keys
    |> URI.encode_query
  end

  @doc """
  Takes a template string and fills it in with stuff in the tuple

  ## Examples
    "customers/:custmer_id/cards/:id" |> fmt({"cus_666", "car_616"})
    # customers/cus_666/cards/car_616
  """
  def fmt(uri, {}), do: uri
  def fmt(uri, tuple) do
    head = elem tuple, 0
    rest = Tuple.delete_at tuple, 0
    uri = uri |> String.replace(~r/:[a-zA-Z0-9_]+/, head, global: false)
    fmt(uri, rest)
  end
end