defmodule ApolloEx.Tracing.Phase.ResolveTrace do
  @moduledoc false

  use Absinthe.Phase

  @doc """
  Creates an Apollo trace and stores it on the given blueprint.

  This aggregates the previous field-level trace data into a trace for the current operation.
  """
  def run(blueprint, _options \\ []) do
    trace = ApolloEx.Tracing.Trace.build(blueprint)
    resolution = %ApolloEx.Tracing.Resolution{trace: trace}
    blueprint = put_in(blueprint.execution.acc[:apollo_ex_tracing], resolution)

    {:ok, blueprint}
  end
end
