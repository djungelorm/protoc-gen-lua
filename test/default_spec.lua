
local test_pb = require 'test_pb'

function reserialize(type, msg)
  local data = msg:SerializeToString()
  local re_msg = type()
  re_msg:ParseFromString(data)
  return re_msg
end

describe("ScalarTypes", function()
  local scalar

  setup(function()
    local msg = test_pb.ScalarTypes()
    msg.double    = 123.456
    msg.int32     = 4452
    msg.int64     = 1232342342
    msg.uint32    = 1232342334
    msg.uint64    = 1232342342
    msg.sint32    = -4452
    msg.sint64    = -123234234
    msg.fixed32   = 268435457
    msg.fixed64   = 720575940
    msg.sfixed32  = -268435457
    msg.sfixed64  = -720575940
    msg.bool      = true
    msg.string    = "hello"
    msg.bytes     = "\xF0\x9F\x98\x81"
    msg.float     = 1.2345
    scalar = reserialize(test_pb.ScalarTypes, msg)
  end)

  it("tests scalar serialization", function()
    assert.are.equal(scalar.double,   123.456)
    assert.are.equal(scalar.int32,    4452)
    assert.are.equal(scalar.int64,    1232342342)
    assert.are.equal(scalar.uint32,   1232342334)
    assert.are.equal(scalar.uint64,   1232342342)
    assert.are.equal(scalar.sint32,   -4452)
    assert.are.equal(scalar.sint64,   -123234234)
    assert.are.equal(scalar.fixed32,  268435457)
    assert.are.equal(scalar.fixed64,  720575940)
    assert.are.equal(scalar.sfixed32, -268435457)
    assert.are.equal(scalar.sfixed64, -720575940)
    assert.is_true(scalar.bool)
    assert.are.equal(scalar.string, "hello")
    assert.are.equal(scalar.bytes, "\xF0\x9F\x98\x81")
    assert.are.equal(string.format("%.4f", scalar.float), string.format("%.4f", 1.2345))
  end)
end)

describe("Enums", function()
  local enums
  local default_enums

  setup(function()
    local msg = test_pb.Enums()
    local default_msg = test_pb.Enums()
    msg.enum = test_pb.Enum.SOMETHING
    enums = reserialize(test_pb.Enums, msg)
    default_enums = reserialize(test_pb.Enums, default_msg)
  end)

  it("tests enum serialization", function()
    assert.are.equal(enums.enum, test_pb.Enum.SOMETHING)
    assert.are.equal(default_enums.enum, test_pb.Enum.ANOTHER_THING)
  end)
end)

describe("Extended", function()
  local extended

  setup(function()
    local msg = test_pb.Extended()
    local extensions = msg.Extensions[test_pb.Extension.exts]
    local ext = extensions:add()
    local ext2 = extensions:add()
    ext.value = "hello"
    ext2.value = "there"
    extended = reserialize(test_pb.Extended, msg)
  end)

  it("tests extension serialization", function()
    local exts = extended.Extensions[test_pb.Extension.exts]
    assert.are.equal(exts[1].value, "hello")
    assert.are.equal(exts[2].value, "there")
  end)
end)

describe("Embed", function()
  local embed

  setup(function()
    local msg = test_pb.Embed()
    local embedded = test_pb.Embedded()
    embedded.value = "hello"
    msg.embedded.value = embedded.value
    embed = reserialize(test_pb.Embed, msg)
  end)

  it("tests embedded message serialization", function()
    assert.are.equal(embed.embedded.value, "hello")
  end)
end)

