defmodule ApolloEx.TracingTest do
  use ExUnit.Case
  doctest ApolloEx

  defmodule ExampleSchema do
    use Absinthe.Schema

    import_sdl("""
    type User {
      id: Int
      name: String
      posts(limit: Int): [Post]
    }

    type Post {
      id: Int
      title: String
      views: Int
      author: User
    }

    type Query {
      aString: String
      aBoolean: Boolean
      anInt: Int
      author(id: Int): User
      topPosts(limit: Int): [Post]
    }
    """)

    def middleware(middleware, _, %{identifier: :subscription}), do: middleware

    def middleware(middleware, _, _),
      do: [ApolloEx.Tracing.Middleware.NodeTraceData] ++ middleware

    def plugins() do
      []
    end

    def hydrate(%{identifier: :author}, [%{identifier: :query} | _]) do
      {:resolve, &__MODULE__.resolve_author/3}
    end

    def hydrate(%{identifier: :aBoolean}, [%{identifier: :query} | _]) do
      {:resolve, &__MODULE__.resolve_a_boolean/3}
    end

    def hydrate(%{identifier: :posts}, _) do
      {:resolve, &__MODULE__.resolve_posts/3}
    end

    def hydrate(_node, _ancestors) do
      []
    end

    def resolve_author(_, _, _) do
      {:ok, author_fixture()}
    end

    def resolve_a_boolean(_, _, _) do
      {:ok, true}
    end

    def resolve_posts(_, _, _) do
      {:ok, [post_fixture(), post_fixture()]}
    end

    defp author_fixture() do
      %{id: 1, name: "Mark Twain"}
    end

    defp post_fixture() do
      %{
        id: 1,
        title: "My Post",
        views: 0
      }
    end
  end

  test "given a simple query, returns correct trace in extensions data" do
    query = """
    query q {
      aBoolean
    }
    """

    assert %{
             root: %{
               child: [
                 %{
                   child: [],
                   end_time: end_time,
                   error: nil,
                   id: nil,
                   original_field_name: "aBoolean",
                   parent_type: "Query",
                   start_time: start_time,
                   type: "Boolean"
                 }
               ]
             }
           } = trace = get_query_trace_from_extensions_data(ExampleSchema, query)

    assert can_encode(trace)
    assert end_time > start_time
  end

  test "given a query with multiple fields, returns correct trace in extensions data" do
    query = """
    query q {
      aBoolean
      aString
    }
    """

    assert %{
             root: %{
               child: [
                 %{
                   child: [],
                   original_field_name: "aBoolean",
                   parent_type: "Query",
                   type: "Boolean"
                 },
                 %{
                   child: [],
                   original_field_name: "aString",
                   parent_type: "Query",
                   type: "String"
                 }
               ]
             }
           } = trace = get_query_trace_from_extensions_data(ExampleSchema, query)

    assert can_encode(trace)
  end

  test "given a query with field that is an object, returns correct trace in extensions data" do
    query = """
    query q {
      author(id: 0) {
        name
        posts(limit: 0) {
          id
        }
      }
    }
    """

    assert %{
             root: %{
               child: [
                 %{
                   type: "User",
                   error: nil,
                   child: [
                     %{
                       child: [],
                       error: nil,
                       original_field_name: "name",
                       parent_type: "User",
                       type: "String"
                     },
                     %{
                       type: "[Post]",
                       error: nil,
                       child: [posts_child_trace_1, posts_child_trace_2],
                       parent_type: "User",
                       original_field_name: "posts"
                     }
                   ],
                   parent_type: "Query",
                   original_field_name: "author"
                 }
               ]
             }
           } = trace = get_query_trace_from_extensions_data(ExampleSchema, query)

    assert %{
             index: 0,
             child: [
               %{
                 child: [],
                 error: nil,
                 original_field_name: "id",
                 parent_type: "Post",
                 type: "Int"
               }
             ]
           } = posts_child_trace_1

    assert %{
             index: 1,
             child: [
               %{
                 child: [],
                 error: nil,
                 original_field_name: "id",
                 parent_type: "Post",
                 type: "Int"
               }
             ]
           } = posts_child_trace_2

    assert can_encode(trace)
  end

  @tag :skip
  test "builds valid query signature"

  @tag :skip
  test "supports multiple operations"

  @tag :skip
  test "supports field aliases"

  @tag :skip
  test "supports result errors"

  @tag :skip
  test "doubly-nested lists of objects"

  @tag :skip
  test "supports fragments"

  @tag :skip
  test "supports traces_pre_aggregated report flag"

  defp get_query_trace_from_extensions_data(schema, query) do
    pipeline =
      schema
      |> Absinthe.Pipeline.for_document()
      |> ApolloEx.Tracing.modify_pipeline([])

    case Absinthe.Pipeline.run(query, pipeline) do
      {:ok, %{result: result}, _phases} ->
        extract_trace(result)

      {:error, msg, _phases} ->
        {:error, msg}
    end
  end

  defp can_encode(trace) do
    ApolloEx.Protos.Trace.encode(trace)
  end

  defp extract_trace(query_result)
  defp extract_trace(%{extensions: %{apollo_ex_tracing: %{trace: trace}}}), do: trace

  defp extract_trace(query_result),
    do: raise("Could not find trace in query result. result: #{inspect(query_result)}")
end
