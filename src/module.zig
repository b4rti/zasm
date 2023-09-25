const std = @import("std");

const Module = struct {
    allocator: std.mem.Allocator,
    version: u32,
    sections: []const Section,

    fn fromSlice(allocator: *std.mem.Allocator, slice: []const u8) !Module {
        _ = slice;
        var module = Module{
            .allocator = allocator,
        };

        return module;
    }

    fn fromPath(allocator: *std.mem.Allocator, path: []const u8) !Module {
        var file = try std.fs.cwd().openFile(path, .{ .mode = .read });
        defer file.close();

        var file_size = try file.seekEnd(0);
        try file.seekAbsolute(0);

        var buffer = try allocator.alloc(u8, file_size);
        defer allocator.free(buffer);

        try file.read(buffer);

        return try Module.fromSlice(allocator, buffer);
    }
};

const Section = union(SectionID) {
    custom: struct {
        name: []const u8,
        data: []const u8,
    },
    name: struct {
        names: []const union(u8) {
            module: struct {
                name: []const u8,
            },
            function: struct {
                index: u32,
                name: []const u8,
            },
            local: struct {
                function_index: u32,
                local_index: u32,
                name: []const u8,
            },
            type: struct {
                index: u32,
                name: []const u8,
            },
            table: struct {
                index: u32,
                name: []const u8,
            },
            memory: struct {
                index: u32,
                name: []const u8,
            },
            global: struct {
                index: u32,
                name: []const u8,
            },
            element: struct {
                index: u32,
                name: []const u8,
            },
            data: struct {
                index: u32,
                name: []const u8,
            },
            tag: struct {
                index: u32,
                name: []const u8,
            },
        },
    },
    type: struct {
        types: []const struct {
            params: []const ValueType,
            results: []const ValueType,
        },
    },
    import: struct {
        imports: []const struct {
            module: []const u8,
            name: []const u8,
            description: union(u8) {
                function: struct {
                    type_index: u32,
                },
                table: struct {
                    type: ValueType,
                    limits: struct {
                        min: u32,
                        max: u32,
                    },
                },
                memory: struct {
                    limits: struct {
                        min: u32,
                        max: u32,
                    },
                },
                global: struct {
                    type: ValueType,
                    mutability: bool,
                },
            },
        },
    },
    function: struct {
        type_indicies: []const u32,
    },
    table: struct {
        tables: []const struct {
            type: ValueType,
            limits: struct {
                min: u32,
                max: u32,
            },
        },
    },
    memory: struct {
        memories: []const struct {
            limits: struct {
                has_max: bool,
                min: u32,
                max: u32,
            },
        },
    },
    global: struct {
        globals: []const struct {
            type: ValueType,
            mutability: bool,
            init: []const u8,
        },
    },
    @"export": struct {
        exports: []const struct {
            name: []const u8,
            description: union(u8) {
                function: struct {
                    index: u32,
                },
                table: struct {
                    index: u32,
                },
                memory: struct {
                    index: u32,
                },
                global: struct {
                    index: u32,
                },
            },
        },
    },
    start: struct {
        index: u32,
    },
    element: struct {
        segments: []const struct {
            index: u32,
            offset: []const u8,
            init: []const u8,
        },
    },
    code: struct {
        bodies: []const struct {
            locals: []const struct {
                count: u32,
                type: ValueType,
            },
            code: []const u8,
        },
    },
    data: struct {
        segments: []const struct {
            index: u32,
            offset: []const u8,
            init: []const u8,
        },
    },
};

const SectionID = enum(u8) {
    // zig fmt: off
    custom      = 0x00,
    type        = 0x01,
    import      = 0x02,
    function    = 0x03,
    table       = 0x04,
    memory      = 0x05,
    global      = 0x06,
    @"export"   = 0x07,
    start       = 0x08,
    element     = 0x09,
    code        = 0x0A,
    data        = 0x0B,
    // zig fmt: on
};

const ValueType = enum(u8) {
    // zig fmt: off
    i32         = 0x7F,
    i64         = 0x7E,
    f32         = 0x7D,
    f64         = 0x7C,
    v128        = 0x7B,
    funcref     = 0x70,
    externref   = 0x6F,
    anyref      = 0x6E,
    eqref       = 0x6D,
    i31ref      = 0x6C,
    dataref     = 0x68,
    // zig fmt: on
};
