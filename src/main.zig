const std = @import("std");
const print = std.debug.print;

const Module = @import("module.zig").Module;
const Engine = @import("engine.zig").Engine;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .verbose_log = false }){};
    const allocator = gpa.allocator();

    var args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    _ = try Module.fromPath(allocator, args[1]);
}
