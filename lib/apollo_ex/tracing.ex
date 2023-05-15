defmodule ApolloEx.Tracing do
  @spec modify_pipeline(Absinthe.Pipeline.t(), Keyword.t()) :: Absinthe.Pipeline.t()
  @doc """
  In order for traces to be generated, `ApolloEx` requires custom Absinthe pipeline phases.

  ## Usage

  For details on usage, see the README.

  """
  def modify_pipeline(pipeline, _options) do
    pipeline
    |> Absinthe.Pipeline.insert_before(
      Absinthe.Phase.Document.Result,
      ApolloEx.Tracing.Phase.ResolveTrace
    )
    |> Absinthe.Pipeline.insert_after(
      Absinthe.Phase.Document.Result,
      ApolloEx.Tracing.Phase.AddTracingExtension
    )
  end
end
