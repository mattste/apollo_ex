# ApolloEx

<!-- MDOC !-->

A library for working with Absinthe and Apollo Studio. It currently supports sending Apollo-compatible usage tracing to Apollo Studio/GraphOS.

For documentation on Apollo usage reporting/tracing, see `ApolloEx.Tracing`.

## Tracing

`ApolloEx.Tracing` currently supports building a valid trace for a given GraphQL query. You can see the built query by inspecting the `extensions` field in the GraphQL response. For more details on Apollo usage reporting, see their documentation [here](https://www.apollographql.com/docs/graphos/metrics/sending-operation-metrics#adding-support-to-a-third-party-server-advanced).

`ApolloEx.Tracing` support for pushing the traces from Absinthe to GraphOS is currently a WIP.

### Usage

In order for traces to be generated, `ApolloEx` requires custom Absinthe pipeline phases.

If you're using `Absinthe.run/3`, you can use this function as the `pipeline_modifier` option.

```
Absinthe.run(query, MyAppWeb.Schema, pipeline_modifier: ApolloEx.Tracing.modify_pipeline/2)
```

If you're using `Absinthe.Plug`, you can use this function for the `pipeline` option. For more details, see [`Absinthe.Plug` documentation](https://hexdocs.pm/absinthe_plug/Absinthe.Plug.html#t:opts/0).

```
plug Absinthe.Plug,
  schema: MyAppWeb.Schema,
  pipeline: {ApolloEx.Tracing, :modify_pipeline}
```

<!-- MDOC !-->

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `apollo_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:apollo_ex, "~> 0.1.0"}
  ]
end
```

## Credits

There have been a few attempts by some excellent community members at this in the past but most attempts have been abandoned. Unfortunately, they are not valid with the latest usage reporting specification. I ran into these issues trying to use the previous libraries in production.

This project aims to distinguish itself by being valid, extensively tested and providing more tools for interacting with GraphOS in the future.

Prior work:

- [Absinthe Federation](https://github.com/DivvyPayHQ/absinthe_federation/pull/25)
- [ApolloTracing](https://github.com/sikanhe/apollo-tracing-elixir)
- [AbsintheTraceReporter](https://github.com/maartenvanvliet/absinthe_trace_reporter)

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/apollo_ex>.
