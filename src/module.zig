const std = @import("std");

pub const Module = struct {
    allocator: std.mem.Allocator,
    sections: []const Section,

    pub fn fromSlice(allocator: std.mem.Allocator, slice: []const u8) !Module {
        var buffer = std.io.fixedBufferStream(slice);
        var reader = buffer.reader();

        try checkMagic(&reader);
        try checkVersion(&reader);

        var sections = std.ArrayList(Section).init(allocator);

        while (true) {
            const section_id_byte = reader.readByte() catch break;
            const section_id: SectionID = @enumFromInt(section_id_byte);
            switch (section_id) {
                .custom => {
                    std.debug.print("Custom Section\n", .{});
                    const section = try parseCustomSectionData(allocator, reader);
                    try sections.append(section);
                },
                .type => {
                    std.debug.print("Type Section\n", .{});
                    const section = try parseTypeSectionData(allocator, reader);
                    try sections.append(section);
                },
                .import => {
                    std.debug.print("Import Section\n", .{});
                    const section = try parseImportSectionData(allocator, reader);
                    try sections.append(section);
                },
                .function => {
                    std.debug.print("Function Section\n", .{});

                    const size = try std.leb.readULEB128(u32, reader);
                    std.debug.print("    Section size: {}\n", .{size});

                    try reader.skipBytes(size, .{});

                    try sections.append(Section{
                        .function = .{ .type_indicies = undefined },
                    });
                },
                .table => {
                    std.debug.print("Table Section\n", .{});

                    const size = try std.leb.readULEB128(u32, reader);
                    std.debug.print("    Section size: {}\n", .{size});

                    try reader.skipBytes(size, .{});

                    try sections.append(Section{
                        .table = .{ .tables = undefined },
                    });
                },
                .memory => {
                    std.debug.print("Memory Section\n", .{});

                    const size = try std.leb.readULEB128(u32, reader);
                    std.debug.print("    Section size: {}\n", .{size});

                    try reader.skipBytes(size, .{});

                    try sections.append(Section{
                        .memory = .{ .memories = undefined },
                    });
                },
                .global => {
                    std.debug.print("Global Section\n", .{});

                    const size = try std.leb.readULEB128(u32, reader);
                    std.debug.print("    Section size: {}\n", .{size});

                    try reader.skipBytes(size, .{});

                    try sections.append(Section{
                        .global = .{ .globals = undefined },
                    });
                },
                .@"export" => {
                    std.debug.print("Export Section\n", .{});

                    const size = try std.leb.readULEB128(u32, reader);
                    std.debug.print("    Section size: {}\n", .{size});

                    try reader.skipBytes(size, .{});

                    try sections.append(Section{
                        .@"export" = .{ .exports = undefined },
                    });
                },
                .start => {
                    std.debug.print("Start Section\n", .{});

                    const size = try std.leb.readULEB128(u32, reader);
                    std.debug.print("    Section size: {}\n", .{size});

                    try reader.skipBytes(size, .{});

                    try sections.append(Section{
                        .start = .{ .index = undefined },
                    });
                },
                .element => {
                    std.debug.print("Element Section\n", .{});

                    const size = try std.leb.readULEB128(u32, reader);
                    std.debug.print("    Section size: {}\n", .{size});

                    try reader.skipBytes(size, .{});

                    try sections.append(Section{
                        .element = .{ .segments = undefined },
                    });
                },
                .code => {
                    std.debug.print("Code Section\n", .{});

                    const size = try std.leb.readULEB128(u32, reader);
                    std.debug.print("    Section size: {}\n", .{size});

                    try reader.skipBytes(size, .{});

                    try sections.append(Section{
                        .code = .{ .bodies = undefined },
                    });
                },
                .data => {
                    std.debug.print("Data Section\n", .{});

                    const size = try std.leb.readULEB128(u32, reader);
                    std.debug.print("    Section size: {}\n", .{size});

                    try reader.skipBytes(size, .{});

                    try sections.append(Section{
                        .data = .{ .segments = undefined },
                    });
                },
            }
        }

        return Module{
            .allocator = allocator,
            .sections = try sections.toOwnedSlice(),
        };
    }

    pub fn fromPath(allocator: std.mem.Allocator, path: []const u8) !Module {
        var file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
        defer file.close();

        const slice = try file.readToEndAlloc(allocator, std.math.maxInt(u32));

        return try Module.fromSlice(allocator, slice);
    }

    fn checkMagic(reader: anytype) !void {
        var magic: [4]u8 = undefined;
        _ = try reader.readAll(&magic);
        if (!std.mem.eql(u8, &magic, &[4]u8{ 0x00, 0x61, 0x73, 0x6D })) {
            return error.InvalidMagicNumber;
        }
    }

    fn checkVersion(reader: anytype) !void {
        var version: [4]u8 = undefined;
        _ = try reader.readAll(&version);
        std.debug.print("Version: {}.{}.{}.{}\n", .{ version[0], version[1], version[2], version[3] });
        if (!std.mem.eql(u8, &version, &[4]u8{ 0x01, 0x00, 0x00, 0x00 })) {
            return error.UnsupportedVersion;
        }
    }

    fn parseCustomSectionData(allocator: std.mem.Allocator, reader: anytype) !Section {
        const size = try std.leb.readULEB128(u32, reader);
        std.debug.print("    Section size: {}\n", .{size});

        var section_bytes = try allocator.alloc(u8, size);
        _ = try reader.readAll(section_bytes);

        return Section{
            .custom = .{
                .name = "",
                .data = undefined,
            },
        };
    }

    fn parseTypeSectionData(allocator: std.mem.Allocator, reader: anytype) !Section {
        const size = try std.leb.readULEB128(u32, reader);
        std.debug.print("    Section size: {}\n", .{size});

        const count = try std.leb.readULEB128(u32, reader);
        std.debug.print("    Type count: {}\n", .{count});

        var section_bytes = try allocator.alloc(u8, size - 1);
        _ = try reader.readAll(section_bytes);
        var types = std.ArrayList(TypeSectionData).init(allocator);

        var type_iter = std.mem.tokenize(u8, section_bytes, "\x60");
        while (type_iter.peek() != null) {
            const type_bytes = type_iter.next().?;

            const params_count = type_bytes[0];
            const params_bytes = type_bytes[1 .. params_count + 1];
            const returns_count = type_bytes[params_count + 1];
            const returns_bytes = type_bytes[params_count + 2 .. params_count + 2 + returns_count];

            var params_list = std.ArrayList(ValueType).init(allocator);
            for (params_bytes) |param| {
                try params_list.append(@enumFromInt(param));
            }

            var returns_list = std.ArrayList(ValueType).init(allocator);
            for (returns_bytes) |returns_byte| {
                try returns_list.append(@enumFromInt(returns_byte));
            }

            var type_def = TypeSectionData{
                .params = try params_list.toOwnedSlice(),
                .returns = try returns_list.toOwnedSlice(),
            };

            std.debug.print("        {}\n", .{type_def});
            try types.append(type_def);
        }

        return Section{
            .type = .{ .types = try types.toOwnedSlice() },
        };
    }

    fn parseImportSectionData(allocator: std.mem.Allocator, reader: anytype) !Section {
        const size = try std.leb.readULEB128(u32, reader);
        std.debug.print("    Section size: {}\n", .{size});

        var section_bytes = try allocator.alloc(u8, size);
        _ = try reader.readAll(section_bytes);

        return Section{
            .import = .{ .imports = undefined },
        };
    }
};

const Section = union(SectionID) {
    custom: struct {
        name: []const u8,
        data: []const u8,
    },
    type: struct {
        types: []const TypeSectionData,
    },
    import: struct {
        imports: []const ImportSectionData,
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
            description: union {
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
    @"type"     = 0x01,
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

const TypeSectionData = struct {
    params: []const ValueType,
    returns: []const ValueType,
};

const ImportSectionData = struct {
    module: []const u8,
    name: []const u8,
    description: union {
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
};
