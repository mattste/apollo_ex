defmodule ApolloEx.Tracing.Resolution do
  @moduledoc """
  Information about the tracing resolution. This is passed along our custom tracing phases to update the trace.
  """
  @type t :: %{
          trace: ApolloEx.Protos.Trace.t() | nil
        }

  @enforce_keys [:trace]
  defstruct [:trace]
end
