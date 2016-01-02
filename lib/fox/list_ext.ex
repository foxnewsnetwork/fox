defmodule Fox.ListExt do
  
  @doc """
  returns everything except the last member of a list

  ### Examples
      iex> [1,2,3] |> head
      [1,2]
      iex> [] |> head
      []

  """
  @spec head(List.t) :: List.t
  def head([]), do: []
  def head(xs) do
    Enum.slice(xs, 0, Enum.count(xs) - 1)
  end

  @doc """
  returns everything except the first member of a list

  ### Examples
      iex> [1,2,3] |> tail
      [2,3]
  """
  @spec tail(List.t) :: List.t
  def tail([]), do: []
  def tail([_|xs]), do: xs
end