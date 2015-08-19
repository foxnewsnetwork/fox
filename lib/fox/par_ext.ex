defmodule Fox.ParExt do
  defmacro {input1, input2} |> {transform1, transform2} do
    import Kernel, only: [{:|>, 2}]
    quote do
      t1 = Task.async(fn -> unquote(input1) |> unquote(transform1) end)
      t2 = Task.async(fn -> unquote(input2) |> unquote(transform2) end)
      {Task.await(t1), Task.await(t2)}
    end
  end
end