defmodule Fox.RandomExt do
  @doc """
  Does the same thing as :random.uniform/1, except it messes up the seeds for slightly more true random.
  """
  def uniform(n) do
    :os.timestamp |> :random.seed
    :random.uniform(n)
  end
end