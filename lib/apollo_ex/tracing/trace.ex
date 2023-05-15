defmodule ApolloEx.Tracing.Trace do
  @moduledoc """
  Helper methods for building and modifying a trace.
  """

  @type result_node ::
          Absinthe.Blueprint.Result.Object.t()
          | Absinthe.Blueprint.Result.Leaf.t()
          | Absinthe.Blueprint.Result.List.t()

  @doc """
  Builds an Apollo-formatted trace from the given blueprint.

  Please see module documentation for how to instrument your Absinthe pipeline so a trace can be created.
  """
  @spec build(Absinthe.Blueprint.t()) :: ApolloEx.Protos.Trace.t()
  def build(%Absinthe.Blueprint{} = blueprint) do
    trace = build_trace_from_result_node(blueprint.execution.result)

    trace = %ApolloEx.Protos.Trace{
      root: trace
    }

    trace
  end

  @doc """
  Encodes the given trace.
  """
  def encode(trace) do
    ApolloEx.Protos.Trace.encode(trace)
  end

  @doc """
  Decode the given trace.
  """
  def decode(trace_binary) do
    ApolloEx.Protos.Trace.decode(trace_binary)
  end

  @spec build_trace_from_result_node(result_node) :: ApolloEx.Protos.Trace.Node.t()
  defp build_trace_from_result_node(result_node)

  defp build_trace_from_result_node(%Absinthe.Blueprint.Result.Object{} = node) do
    node_tracing_data = result_object_node_tracing_data(node)

    child =
      Enum.map(node.fields, fn field ->
        build_trace_from_result_node(field)
      end)

    tracing_data = Map.put(node_tracing_data, :child, child)
    tracing_data
  end

  defp build_trace_from_result_node(
         %Absinthe.Blueprint.Result.List{
           extensions: %{ApolloEx.Tracing.Middleware.NodeTraceData => node_tracing_data}
         } = node
       ) do
    child =
      node.values
      |> Enum.with_index()
      |> Enum.map(fn {field, index} ->
        child_trace = build_trace_from_result_node(field)
        %{index: index, child: child_trace.child}
      end)

    tracing_data = Map.put(node_tracing_data, :child, child)
    tracing_data
  end

  defp build_trace_from_result_node(
         %Absinthe.Blueprint.Result.Leaf{
           extensions: %{ApolloEx.Tracing.Middleware.NodeTraceData => node_tracing_data}
         } = node
       ) do
    field_name = node.emitter.name

    node_tracing_data
    |> Map.put(:name, field_name)
  end

  defp result_object_node_tracing_data(result_object_node)

  defp result_object_node_tracing_data(%Absinthe.Blueprint.Result.Object{
         extensions: %{ApolloEx.Tracing.Middleware.NodeTraceData => node_tracing_data}
       }),
       do: node_tracing_data

  # handles root node that doesn't contain existing middleware tracing data
  defp result_object_node_tracing_data(%Absinthe.Blueprint.Result.Object{}), do: %{}
end
