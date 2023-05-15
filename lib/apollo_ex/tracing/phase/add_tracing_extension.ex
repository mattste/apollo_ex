defmodule ApolloEx.Tracing.Phase.AddTracingExtension do
  @moduledoc false

  use Absinthe.Phase

  @doc """
  Puts the trace for the given operation onto the result.extensions field.
  """
  def run(blueprint, _options \\ []) do
    extensions = Map.get(blueprint.result, :extensions, %{})

    extensions =
      case Map.get(blueprint.execution.acc, :apollo_ex_tracing) do
        nil ->
          extensions

        %ApolloEx.Tracing.Resolution{} = resolution ->
          Map.put(extensions, :apollo_ex_tracing, resolution)
      end

    result = Map.put(blueprint.result, :extensions, extensions)

    {:ok, %{blueprint | result: result}}
  end
end
