defmodule ApolloEx.Tracing.Middleware.NodeTraceData do
  @moduledoc false

  @behaviour Absinthe.Middleware

  alias ApolloEx.Protos

  @doc """
  Stores Apollo trace data for a given field on the field's `Absinthe.Resolution` struct.

  Data can be accessed via the field's `resolution.extensions` field. For example,
  ```
  %Absinthe.Resolution{
    extensions: %{
      ApolloEx.Tracing.Middleware.NodeTraceData => %ApolloEx.Protos.Trace.Node{}
    }
  }
  ```
  """
  def call(%Absinthe.Resolution{} = resolution, _config) do
    start_time = System.os_time(:nanosecond)
    field_name = resolution.definition.name
    type = Absinthe.Type.name(resolution.definition.schema_node.type, resolution.schema)
    parent_type = Absinthe.Type.name(resolution.parent_type, resolution.schema)

    field_trace_data = %Protos.Trace.Node{
      original_field_name: field_name,
      type: type,
      parent_type: parent_type,
      start_time: start_time,
      end_time: nil,
      error: nil
    }

    middleware = resolution.middleware ++ [{{__MODULE__, :on_complete}, field_trace_data}]

    %{
      resolution
      | extensions: Map.put(resolution.extensions, __MODULE__, field_trace_data),
        middleware: middleware
    }
  end

  def call(resolution, _) do
    resolution
  end

  def on_complete(
        %Absinthe.Resolution{state: :resolved} = resolution,
        field_trace_data
      ) do
    case field_trace_data do
      nil ->
        resolution

      %Protos.Trace.Node{} = field_trace_data ->
        end_time = System.os_time(:nanosecond)
        field_trace_data = %{field_trace_data | end_time: end_time}

        extensions = Map.put(resolution.extensions, __MODULE__, field_trace_data)

        %{resolution | extensions: extensions}
    end
  end
end
