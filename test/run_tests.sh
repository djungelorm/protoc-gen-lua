#!/bin/bash

DIR=`dirname $0`
protoc --plugin="$DIR/../protoc-plugin/protoc-gen-lua" --lua_out=${DIR} ${DIR}/*.proto &&
busted .
