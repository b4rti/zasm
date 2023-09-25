const std = @import("std");

const Tag = enum(u8) {
    a = 1,
    b = 2,
    c = 3,
};

const TaggedUnion = union(Tag) {
    a: u8,
    b: i8,
    c: void,
};

pub fn main() void {
    const t = TaggedUnion{ .a = 16 };
    std.debug.print("{}", .{t});
}
