defmodule ApolloEx.Protos.Trace.CachePolicy.Scope do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :UNKNOWN, 0
  field :PUBLIC, 1
  field :PRIVATE, 2
end

defmodule ApolloEx.Protos.Trace.HTTP.Method do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :UNKNOWN, 0
  field :OPTIONS, 1
  field :GET, 2
  field :HEAD, 3
  field :POST, 4
  field :PUT, 5
  field :DELETE, 6
  field :TRACE, 7
  field :CONNECT, 8
  field :PATCH, 9
end

defmodule ApolloEx.Protos.Trace.CachePolicy do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :scope, 1, type: ApolloEx.Protos.Trace.CachePolicy.Scope, enum: true
  field :max_age_ns, 2, type: :int64, json_name: "maxAgeNs"
end

defmodule ApolloEx.Protos.Trace.Details.VariablesJsonEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :string
end

defmodule ApolloEx.Protos.Trace.Details do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :variables_json, 4,
    repeated: true,
    type: ApolloEx.Protos.Trace.Details.VariablesJsonEntry,
    json_name: "variablesJson",
    map: true

  field :operation_name, 3, type: :string, json_name: "operationName"
end

defmodule ApolloEx.Protos.Trace.Error do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :message, 1, type: :string
  field :location, 2, repeated: true, type: ApolloEx.Protos.Trace.Location
  field :time_ns, 3, type: :uint64, json_name: "timeNs"
  field :json, 4, type: :string
end

defmodule ApolloEx.Protos.Trace.HTTP.Values do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :value, 1, repeated: true, type: :string
end

defmodule ApolloEx.Protos.Trace.HTTP.RequestHeadersEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: ApolloEx.Protos.Trace.HTTP.Values
end

defmodule ApolloEx.Protos.Trace.HTTP.ResponseHeadersEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: ApolloEx.Protos.Trace.HTTP.Values
end

defmodule ApolloEx.Protos.Trace.HTTP do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :method, 1, type: ApolloEx.Protos.Trace.HTTP.Method, enum: true

  field :request_headers, 4,
    repeated: true,
    type: ApolloEx.Protos.Trace.HTTP.RequestHeadersEntry,
    json_name: "requestHeaders",
    map: true

  field :response_headers, 5,
    repeated: true,
    type: ApolloEx.Protos.Trace.HTTP.ResponseHeadersEntry,
    json_name: "responseHeaders",
    map: true

  field :status_code, 6, type: :uint32, json_name: "statusCode"
end

defmodule ApolloEx.Protos.Trace.Location do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :line, 1, type: :uint32
  field :column, 2, type: :uint32
end

defmodule ApolloEx.Protos.Trace.Node do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  oneof :id, 0

  field :response_name, 1, type: :string, json_name: "responseName", oneof: 0
  field :index, 2, type: :uint32, oneof: 0
  field :original_field_name, 14, type: :string, json_name: "originalFieldName"
  field :type, 3, type: :string
  field :parent_type, 13, type: :string, json_name: "parentType"
  field :cache_policy, 5, type: ApolloEx.Protos.Trace.CachePolicy, json_name: "cachePolicy"
  field :start_time, 8, type: :uint64, json_name: "startTime"
  field :end_time, 9, type: :uint64, json_name: "endTime"
  field :error, 11, repeated: true, type: ApolloEx.Protos.Trace.Error
  field :child, 12, repeated: true, type: ApolloEx.Protos.Trace.Node
end

defmodule ApolloEx.Protos.Trace.QueryPlanNode.SequenceNode do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :nodes, 1, repeated: true, type: ApolloEx.Protos.Trace.QueryPlanNode
end

defmodule ApolloEx.Protos.Trace.QueryPlanNode.ParallelNode do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :nodes, 1, repeated: true, type: ApolloEx.Protos.Trace.QueryPlanNode
end

defmodule ApolloEx.Protos.Trace.QueryPlanNode.FetchNode do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :service_name, 1, type: :string, json_name: "serviceName"
  field :trace_parsing_failed, 2, type: :bool, json_name: "traceParsingFailed"
  field :trace, 3, type: ApolloEx.Protos.Trace
  field :sent_time_offset, 4, type: :uint64, json_name: "sentTimeOffset"
  field :sent_time, 5, type: Google.Protobuf.Timestamp, json_name: "sentTime"
  field :received_time, 6, type: Google.Protobuf.Timestamp, json_name: "receivedTime"
end

defmodule ApolloEx.Protos.Trace.QueryPlanNode.FlattenNode do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :response_path, 1,
    repeated: true,
    type: ApolloEx.Protos.Trace.QueryPlanNode.ResponsePathElement,
    json_name: "responsePath"

  field :node, 2, type: ApolloEx.Protos.Trace.QueryPlanNode
end

defmodule ApolloEx.Protos.Trace.QueryPlanNode.DeferNode do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :primary, 1, type: ApolloEx.Protos.Trace.QueryPlanNode.DeferNodePrimary
  field :deferred, 2, repeated: true, type: ApolloEx.Protos.Trace.QueryPlanNode.DeferredNode
end

defmodule ApolloEx.Protos.Trace.QueryPlanNode.ConditionNode do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :condition, 1, type: :string
  field :if_clause, 2, type: ApolloEx.Protos.Trace.QueryPlanNode, json_name: "ifClause"
  field :else_clause, 3, type: ApolloEx.Protos.Trace.QueryPlanNode, json_name: "elseClause"
end

defmodule ApolloEx.Protos.Trace.QueryPlanNode.DeferNodePrimary do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :node, 1, type: ApolloEx.Protos.Trace.QueryPlanNode
end

defmodule ApolloEx.Protos.Trace.QueryPlanNode.DeferredNode do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :depends, 1, repeated: true, type: ApolloEx.Protos.Trace.QueryPlanNode.DeferredNodeDepends
  field :label, 2, type: :string
  field :path, 3, repeated: true, type: ApolloEx.Protos.Trace.QueryPlanNode.ResponsePathElement
  field :node, 4, type: ApolloEx.Protos.Trace.QueryPlanNode
end

defmodule ApolloEx.Protos.Trace.QueryPlanNode.DeferredNodeDepends do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :id, 1, type: :string
  field :defer_label, 2, type: :string, json_name: "deferLabel"
end

defmodule ApolloEx.Protos.Trace.QueryPlanNode.ResponsePathElement do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  oneof :id, 0

  field :field_name, 1, type: :string, json_name: "fieldName", oneof: 0
  field :index, 2, type: :uint32, oneof: 0
end

defmodule ApolloEx.Protos.Trace.QueryPlanNode do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  oneof :node, 0

  field :sequence, 1, type: ApolloEx.Protos.Trace.QueryPlanNode.SequenceNode, oneof: 0
  field :parallel, 2, type: ApolloEx.Protos.Trace.QueryPlanNode.ParallelNode, oneof: 0
  field :fetch, 3, type: ApolloEx.Protos.Trace.QueryPlanNode.FetchNode, oneof: 0
  field :flatten, 4, type: ApolloEx.Protos.Trace.QueryPlanNode.FlattenNode, oneof: 0
  field :defer, 5, type: ApolloEx.Protos.Trace.QueryPlanNode.DeferNode, oneof: 0
  field :condition, 6, type: ApolloEx.Protos.Trace.QueryPlanNode.ConditionNode, oneof: 0
end

defmodule ApolloEx.Protos.Trace do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :start_time, 4, type: Google.Protobuf.Timestamp, json_name: "startTime"
  field :end_time, 3, type: Google.Protobuf.Timestamp, json_name: "endTime"
  field :duration_ns, 11, type: :uint64, json_name: "durationNs"
  field :root, 14, type: ApolloEx.Protos.Trace.Node
  field :is_incomplete, 33, type: :bool, json_name: "isIncomplete"
  field :signature, 19, type: :string
  field :unexecutedOperationBody, 27, type: :string
  field :unexecutedOperationName, 28, type: :string
  field :details, 6, type: ApolloEx.Protos.Trace.Details
  field :client_name, 7, type: :string, json_name: "clientName"
  field :client_version, 8, type: :string, json_name: "clientVersion"
  field :operation_type, 35, type: :string, json_name: "operationType"
  field :operation_subtype, 36, type: :string, json_name: "operationSubtype"
  field :http, 10, type: ApolloEx.Protos.Trace.HTTP
  field :cache_policy, 18, type: ApolloEx.Protos.Trace.CachePolicy, json_name: "cachePolicy"
  field :query_plan, 26, type: ApolloEx.Protos.Trace.QueryPlanNode, json_name: "queryPlan"
  field :full_query_cache_hit, 20, type: :bool, json_name: "fullQueryCacheHit"
  field :persisted_query_hit, 21, type: :bool, json_name: "persistedQueryHit"
  field :persisted_query_register, 22, type: :bool, json_name: "persistedQueryRegister"
  field :registered_operation, 24, type: :bool, json_name: "registeredOperation"
  field :forbidden_operation, 25, type: :bool, json_name: "forbiddenOperation"
  field :field_execution_weight, 31, type: :double, json_name: "fieldExecutionWeight"
end

defmodule ApolloEx.Protos.ReportHeader do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :graph_ref, 12, type: :string, json_name: "graphRef"
  field :hostname, 5, type: :string
  field :agent_version, 6, type: :string, json_name: "agentVersion"
  field :service_version, 7, type: :string, json_name: "serviceVersion"
  field :runtime_version, 8, type: :string, json_name: "runtimeVersion"
  field :uname, 9, type: :string
  field :executable_schema_id, 11, type: :string, json_name: "executableSchemaId"
end

defmodule ApolloEx.Protos.PathErrorStats.ChildrenEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: ApolloEx.Protos.PathErrorStats
end

defmodule ApolloEx.Protos.PathErrorStats do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :children, 1,
    repeated: true,
    type: ApolloEx.Protos.PathErrorStats.ChildrenEntry,
    map: true

  field :errors_count, 4, type: :uint64, json_name: "errorsCount"
  field :requests_with_errors_count, 5, type: :uint64, json_name: "requestsWithErrorsCount"
end

defmodule ApolloEx.Protos.QueryLatencyStats do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :latency_count, 13, repeated: true, type: :sint64, json_name: "latencyCount"
  field :request_count, 2, type: :uint64, json_name: "requestCount"
  field :cache_hits, 3, type: :uint64, json_name: "cacheHits"
  field :persisted_query_hits, 4, type: :uint64, json_name: "persistedQueryHits"
  field :persisted_query_misses, 5, type: :uint64, json_name: "persistedQueryMisses"
  field :cache_latency_count, 14, repeated: true, type: :sint64, json_name: "cacheLatencyCount"
  field :root_error_stats, 7, type: ApolloEx.Protos.PathErrorStats, json_name: "rootErrorStats"
  field :requests_with_errors_count, 8, type: :uint64, json_name: "requestsWithErrorsCount"

  field :public_cache_ttl_count, 15,
    repeated: true,
    type: :sint64,
    json_name: "publicCacheTtlCount"

  field :private_cache_ttl_count, 16,
    repeated: true,
    type: :sint64,
    json_name: "privateCacheTtlCount"

  field :registered_operation_count, 11, type: :uint64, json_name: "registeredOperationCount"
  field :forbidden_operation_count, 12, type: :uint64, json_name: "forbiddenOperationCount"

  field :requests_without_field_instrumentation, 17,
    type: :uint64,
    json_name: "requestsWithoutFieldInstrumentation"
end

defmodule ApolloEx.Protos.StatsContext do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :client_name, 2, type: :string, json_name: "clientName"
  field :client_version, 3, type: :string, json_name: "clientVersion"
  field :operation_type, 4, type: :string, json_name: "operationType"
  field :operation_subtype, 5, type: :string, json_name: "operationSubtype"
end

defmodule ApolloEx.Protos.ContextualizedQueryLatencyStats do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :query_latency_stats, 1,
    type: ApolloEx.Protos.QueryLatencyStats,
    json_name: "queryLatencyStats"

  field :context, 2, type: ApolloEx.Protos.StatsContext
end

defmodule ApolloEx.Protos.ContextualizedTypeStats.PerTypeStatEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: ApolloEx.Protos.TypeStat
end

defmodule ApolloEx.Protos.ContextualizedTypeStats do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :context, 1, type: ApolloEx.Protos.StatsContext

  field :per_type_stat, 2,
    repeated: true,
    type: ApolloEx.Protos.ContextualizedTypeStats.PerTypeStatEntry,
    json_name: "perTypeStat",
    map: true
end

defmodule ApolloEx.Protos.FieldStat do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :return_type, 3, type: :string, json_name: "returnType"
  field :errors_count, 4, type: :uint64, json_name: "errorsCount"
  field :observed_execution_count, 5, type: :uint64, json_name: "observedExecutionCount"
  field :estimated_execution_count, 10, type: :uint64, json_name: "estimatedExecutionCount"
  field :requests_with_errors_count, 6, type: :uint64, json_name: "requestsWithErrorsCount"
  field :latency_count, 9, repeated: true, type: :sint64, json_name: "latencyCount"
end

defmodule ApolloEx.Protos.TypeStat.PerFieldStatEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: ApolloEx.Protos.FieldStat
end

defmodule ApolloEx.Protos.TypeStat do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :per_field_stat, 3,
    repeated: true,
    type: ApolloEx.Protos.TypeStat.PerFieldStatEntry,
    json_name: "perFieldStat",
    map: true
end

defmodule ApolloEx.Protos.ReferencedFieldsForType do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :field_names, 1, repeated: true, type: :string, json_name: "fieldNames"
  field :is_interface, 2, type: :bool, json_name: "isInterface"
end

defmodule ApolloEx.Protos.Report.OperationCountByType do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :type, 1, type: :string
  field :subtype, 2, type: :string
  field :operation_count, 3, type: :uint64, json_name: "operationCount"
end

defmodule ApolloEx.Protos.Report.TracesPerQueryEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: ApolloEx.Protos.TracesAndStats
end

defmodule ApolloEx.Protos.Report do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :header, 1, type: ApolloEx.Protos.ReportHeader

  field :traces_per_query, 5,
    repeated: true,
    type: ApolloEx.Protos.Report.TracesPerQueryEntry,
    json_name: "tracesPerQuery",
    map: true

  field :end_time, 2, type: Google.Protobuf.Timestamp, json_name: "endTime"
  field :operation_count, 6, type: :uint64, json_name: "operationCount"

  field :operation_count_by_type, 8,
    repeated: true,
    type: ApolloEx.Protos.Report.OperationCountByType,
    json_name: "operationCountByType"

  field :traces_pre_aggregated, 7, type: :bool, json_name: "tracesPreAggregated"
end

defmodule ApolloEx.Protos.ContextualizedStats.PerTypeStatEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: ApolloEx.Protos.TypeStat
end

defmodule ApolloEx.Protos.ContextualizedStats do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :context, 1, type: ApolloEx.Protos.StatsContext

  field :query_latency_stats, 2,
    type: ApolloEx.Protos.QueryLatencyStats,
    json_name: "queryLatencyStats"

  field :per_type_stat, 3,
    repeated: true,
    type: ApolloEx.Protos.ContextualizedStats.PerTypeStatEntry,
    json_name: "perTypeStat",
    map: true
end

defmodule ApolloEx.Protos.TracesAndStats.ReferencedFieldsByTypeEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: ApolloEx.Protos.ReferencedFieldsForType
end

defmodule ApolloEx.Protos.TracesAndStats do
  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :trace, 1, repeated: true, type: ApolloEx.Protos.Trace

  field :stats_with_context, 2,
    repeated: true,
    type: ApolloEx.Protos.ContextualizedStats,
    json_name: "statsWithContext"

  field :referenced_fields_by_type, 4,
    repeated: true,
    type: ApolloEx.Protos.TracesAndStats.ReferencedFieldsByTypeEntry,
    json_name: "referencedFieldsByType",
    map: true

  field :internal_traces_contributing_to_stats, 3,
    repeated: true,
    type: ApolloEx.Protos.Trace,
    json_name: "internalTracesContributingToStats"
end