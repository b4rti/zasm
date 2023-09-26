const std = @import("std");
const print = std.debug.print;

const Module = @import("module.zig").Module;
const Engine = @import("engine.zig").Engine;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .verbose_log = false }){};
    const allocator = gpa.allocator();

    var args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const module = try Module.fromPath(allocator, args[1]);
    defer module.deinit();
}

test "module - wasm-test/zig.wasm" {
    const allocator = std.testing.allocator;
    const module = try Module.fromPath(allocator, "wasm-test/zig.wasm");
    defer module.deinit();
}
