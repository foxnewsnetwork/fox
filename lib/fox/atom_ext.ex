defmodule Fox.AtomExt do

  @doc """
  Takes a controller or view module and attempts to infer its model module name. 
  Will error if not given a controller module or the model doesn't exist.

  ## Examples
    MyApp.PictureController |> infer_model_module
    # MyApp.Picture

    MyApp.DogFoodView |> infer_model_module
    # MyApp.DogFood
  """
  def infer_model_module(module) when is_atom(module) do
    module
    |> Atom.to_string
    |> consume_one!("Controller", "View")
    |> String.to_existing_atom
  end
  defp consume_one!(string, first_choice, second_choice) do
    string
    |> Fox.StringExt.reverse_consume(first_choice)
    |> case do
      {:ok, leftover} -> leftover
      {:error, _} -> Fox.StringExt.reverse_consume!(string, second_choice)
    end
  end

  @doc """
  Takes a controller module and attempts to infer the underscored atom key of its model.
  Will throw error if not given a controller or the model doesn't exist

  ## Examples
    MyApp.MikuHatsuneView |> infer_model_key
    # :miku_hatsune

    MyApp.PictureController |> infer_model_key
    # :picture

    MyApp.DonkeyPunchController |> infer_model_key
    # :donkey_punch
  """
  def infer_model_key(module) when is_atom(module) do
    module
    |> infer_model_module
    |> Atom.to_string
    |> String.split(".")
    |> List.last
    |> Fox.StringExt.underscore
    |> Fox.StringExt.singularize
    |> String.to_atom
  end

  @doc """
  Takes a controller module and attempts to infer the underscored atom key of its model's collection.
  Throws error if not given a controller or the model doesn't exist.

  ## Examples
    MyApp.PictureController |> infer_model_key
    # :pictures

    MyApp.DonkeyPunchController |> infer_model_key
    # :donkey_punches
  """
  def infer_collection_key(module) when is_atom(module) do
    module
    |> infer_model_module
    |> Atom.to_string
    |> String.split(".")
    |> List.last
    |> Fox.StringExt.underscore
    |> Fox.StringExt.pluralize
    |> String.to_atom
  end

  defmacro __using__(_) do
    quote location: :keep do
      def infer_model_module do
        __MODULE__ |> Fox.AtomExt.infer_model_module
      end
      def infer_model_key do
        __MODULE__ |> Fox.AtomExt.infer_model_key
      end
      def infer_collection_key do
        __MODULE__ |> Fox.AtomExt.infer_collection_key
      end
    end
  end
end 