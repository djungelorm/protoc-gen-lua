protobuf-lua
============

Lua library for Google's [Protocol Buffers](http://code.google.com/p/protobuf/).
This is a fork of https://github.com/sean-lin/protoc-gen-lua

## Installation and Usage

Using luarocks by running: ```luarocks install protobuf```

Make a link to the protoc plugin, for example:

```ln -s /usr/local/lib/luarocks/rocks/protobuf/1.1.0-0/protoc-plugin/protoc-gen-lua /usr/local/bin/```

proto files can then be compiled using: ```protoc --lua_out=./ foo.proto```

The API is similar to Google's protobuf python library. An example can be found in the example directory.

## Changelog

1. Fixed the issues that are addressed by this PR: https://github.com/djungelorm/protobuf-lua/pull/13
