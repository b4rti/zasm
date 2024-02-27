const std = @import("std");
const print = std.debug.print;

const Module = @import("module.zig").Module;
const Engine = @import("engine.zig").Engine;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .verbose_log = false }){};
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const module = try Module.fromPath(allocator, args[1]);
    defer module.deinit();

    const engine = try Engine.init(allocator);
    defer engine.deinit();

    engine.addModule(module);
}

test "module - wasm-test/add.wasm" {
    const allocator = std.testing.allocator;
    const module = try Module.fromPath(allocator, "wasm-test/add.wasm");
    module.deinit();
}

test "module - wasm-test/hello-world.wasm" {
    const allocator = std.testing.allocator;
    const module = try Module.fromPath(allocator, "wasm-test/hello-world.wasm");
    module.deinit();
}

test "module - wasm-test/wasi-hello-world.wasm" {
    const allocator = std.testing.allocator;
    const module = try Module.fromPath(allocator, "wasm-test/wasi-hello-world.wasm");
    module.deinit();
}

test "module - wasm-test/rustpython.wasm" {
    const allocator = std.testing.allocator;
    const module = try Module.fromPath(allocator, "wasm-test/rustpython.wasm");
    module.deinit();
}

test "module - wasm-test/zig.wasm" {
    const allocator = std.testing.allocator;
    const module = try Module.fromPath(allocator, "wasm-test/zig.wasm");
    module.deinit();
}
