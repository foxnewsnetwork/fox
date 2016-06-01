defmodule Fox.RecordExt do

  def view_for_model(%{__struct__: struct}) do
    struct
    |> Atom.to_string
    |> Kernel.<>("View")
    |> String.to_existing_atom
  end

  def controller_for_model(%{__struct__: struct}) do
    struct
    |> Atom.to_string
    |> Kernel.<>("Controller")
    |> String.to_existing_atom
  end

  def infer_model_key(%{__struct__: struct}) do
    struct |> Fox.AtomExt.infer_model_key
  end

  def infer_collection_key(%{__struct__: struct}) do
    struct |> Fox.AtomExt.infer_collection_key
  end
end