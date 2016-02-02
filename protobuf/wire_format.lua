--
--------------------------------------------------------------------------------
--  FILE:  wire_format.lua
--  DESCRIPTION:  protoc-gen-lua
--      Google's Protocol Buffers project, ported to lua.
--      https://code.google.com/p/protoc-gen-lua/
--
--      Copyright (c) 2010 , 林卓毅 (Zhuoyi Lin) netsnail@gmail.com
--      All rights reserved.
--
--      Use, modification and distribution are subject to the "New BSD License"
--      as listed at <url: http://www.opensource.org/licenses/bsd-license.php >.
--
--  COMPANY:  NetEase
--  CREATED:  2010年07月30日 15时59分53秒 CST
--------------------------------------------------------------------------------
--

local pb = require "protobuf.pb"

local wire_format = {}

wire_format.WIRETYPE_VARINT = 0
wire_format.WIRETYPE_FIXED64 = 1
wire_format.WIRETYPE_LENGTH_DELIMITED = 2
wire_format.WIRETYPE_START_GROUP = 3
wire_format.WIRETYPE_END_GROUP = 4
wire_format.WIRETYPE_FIXED32 = 5
_WIRETYPE_MAX = 5

-- we don't need uint64
local function _VarUInt64ByteSizeNoTag(uint64)
  if uint64 <= 0x7f then return 1 end
  if uint64 <= 0x3fff then return 2 end
  if uint64 <= 0x1fffff then return 3 end
  if uint64 <= 0xfffffff then return 4 end
  if uint64 <= 0x7ffffffff then return 5 end
  if uint64 <= 0x3ffffffffff then return 6 end
  if uint64 <= 0x1ffffffffffff then return 7 end
  if uint64 <= 0xffffffffffffff then return 8 end
  if uint64 <= 0x7fffffffffffffff then return 9 end
  return 10
end

function wire_format.PackTag(field_number, wire_type)
  return field_number * 8 + wire_type
end

function wire_format.UnpackTag(tag)
  local wire_type = tag % 8
  return (tag - wire_type) / 8, wire_type
end

wire_format.ZigZagEncode32 = pb.zig_zag_encode32
wire_format.ZigZagDecode32 = pb.zig_zag_decode32
wire_format.ZigZagEncode64 = pb.zig_zag_encode64
wire_format.ZigZagDecode64 = pb.zig_zag_decode64

function wire_format.Int32ByteSize(field_number, int32)
  return wire_format.Int64ByteSize(field_number, int32)
end

function wire_format.Int32ByteSizeNoTag(int32)
  return _VarUInt64ByteSizeNoTag(int32)
end

function wire_format.Int64ByteSize(field_number, int64)
  return wire_format.UInt64ByteSize(field_number, int64)
end

function wire_format.UInt32ByteSize(field_number, uint32)
  return wire_format.UInt64ByteSize(field_number, uint32)
end

function wire_format.UInt64ByteSize(field_number, uint64)
  return wire_format.TagByteSize(field_number) + _VarUInt64ByteSizeNoTag(uint64)
end

function wire_format.SInt32ByteSize(field_number, int32)
  return wire_format.UInt32ByteSize(field_number, wire_format.ZigZagEncode(int32))
end

function wire_format.SInt64ByteSize(field_number, int64)
  return wire_format.UInt64ByteSize(field_number, wire_format.ZigZagEncode(int64))
end

function wire_format.Fixed32ByteSize(field_number, fixed32)
  return wire_format.TagByteSize(field_number) + 4
end

function wire_format.Fixed64ByteSize(field_number, fixed64)
  return wire_format.TagByteSize(field_number) + 8
end

function wire_format.SFixed32ByteSize(field_number, sfixed32)
  return wire_format.TagByteSize(field_number) + 4
end

function wire_format.SFixed64ByteSize(field_number, sfixed64)
  return wire_format.TagByteSize(field_number) + 8
end

function wire_format.FloatByteSize(field_number, flt)
  return wire_format.TagByteSize(field_number) + 4
end

function wire_format.DoubleByteSize(field_number, double)
  return wire_format.TagByteSize(field_number) + 8
end

function wire_format.BoolByteSize(field_number, b)
  return wire_format.TagByteSize(field_number) + 1
end

function wire_format.EnumByteSize(field_number, enum)
  return wire_format.UInt32ByteSize(field_number, enum)
end

function wire_format.StringByteSize(field_number, string)
  return wire_format.BytesByteSize(field_number, string)
end

function wire_format.BytesByteSize(field_number, b)
  return wire_format.TagByteSize(field_number) + _VarUInt64ByteSizeNoTag(#b) + #b
end

function wire_format.MessageByteSize(field_number, message)
  return wire_format.TagByteSize(field_number) + _VarUInt64ByteSizeNoTag(message.ByteSize()) + message.ByteSize()
end

function wire_format.MessageSetItemByteSize(field_number, msg)
  local total_size = 2 * wire_format.TagByteSize(1) + wire_format.TagByteSize(2) + wire_format.TagByteSize(3)
  total_size = total_size + _VarUInt64ByteSizeNoTag(field_number)
  local message_size = msg.ByteSize()
  total_size = total_size + _VarUInt64ByteSizeNoTag(message_size)
  total_size = total_size + message_size
  return total_size
end

function wire_format.TagByteSize(field_number)
  return _VarUInt64ByteSizeNoTag(PackTag(field_number, 0))
end

return wire_format
