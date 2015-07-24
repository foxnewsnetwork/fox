defmodule Fox.DictExt do
  def reject_blank_keys(dict) do
    bad_keys = Dict.keys(dict) 
    |> Enum.filter(fn key -> is_blank(Dict.get dict, key) end)
    Dict.drop dict, bad_keys
  end

  def is_blank(nil), do: true
  def is_blank(""), do: true
  def is_blank(_), do: false
end