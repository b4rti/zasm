const OPCode = @import("opcode.zig").OPCode;

const Decoder = struct {};

const Instruction = struct {
    opcode: OPCode,
    immediate: []const u8,
};
