#!/bin/bash

### Generate Elixir code from protobuf definition

protoc --proto_path=priv/protobuf/lib/ --proto_path=priv/protobuf/apollo_ex/ --elixir_out=./lib/apollo_ex/protobuf/generated/ --elixir_opt=package_prefix=apollo_ex.protos,include_docs=true priv/protobuf/apollo_ex/reports.proto