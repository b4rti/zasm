const std = @import("std");
const print = std.debug.print;

const Module = @import("module.zig").Module;

pub const Engine = struct {
    allocator: std.mem.Allocator,
    modules: std.ArrayList(Module),

    pub fn init(allocator: std.mem.Allocator) !Engine {
        return Engine{
            .allocator = allocator,
            .modules = std.ArrayList(Module).init(allocator),
        };
    }

    pub fn deinit(self: Engine) void {
        _ = self;
    }

    pub fn addModule(self: Engine, module: Module) void {
        _ = self;
        _ = module;
    }

    pub fn loadModule(self: Engine, path: []const u8) void {
        _ = self;
        _ = Module.fromPath(path);
    }

    pub fn call(self: Engine, name: []const u8, params: []i32) i32 {
        _ = self;
        _ = name;
        _ = params;

        return 0;
    }
};
