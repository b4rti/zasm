const std = @import("std");
const print = std.debug.print;

const Module = @import("module.zig").Module;
const Engine = @import("engine.zig").Engine;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    // const module = try Module.fromPath(allocator, "wasm-test/add.wasm");
    // const module = try Module.fromPath(allocator, "wasm-test/hello-world.wasm");
    const module = try Module.fromPath(allocator, "wasm-test/wasi-hello-world.wasm");
    _ = module;
}
