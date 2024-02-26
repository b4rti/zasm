const std = @import("std");

const SectionReader = std.io.FixedBufferStream([]u8).Reader;

pub const Module = struct {
    allocator: std.mem.Allocator,
    sections: []const Section,

    pub fn fromSlice(allocator: std.mem.Allocator, slice: []const u8) !Module {
        var module_buffer = std.io.fixedBufferStream(slice);
        var module_reader = module_buffer.reader();

        try checkMagic(&module_reader);
        try checkVersion(&module_reader);

        var section_list = std.ArrayList(Section).init(allocator);

        while (true) {
            const section_id: SectionID = @enumFromInt(module_reader.readByte() catch break);

            switch (section_id) {
                .custom => {
                    std.debug.print("Custom Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    const section = try parseCustomSectionData(allocator, section_reader);
                    try section_list.append(section);
                },
                .type => {
                    std.debug.print("Type Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    const section = try parseTypeSectionData(allocator, section_reader);
                    try section_list.append(section);
                },
                .import => {
                    std.debug.print("Import Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    const section = try parseImportSectionData(allocator, section_reader);
                    try section_list.append(section);
                },
                .function => {
                    std.debug.print("Function Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    const section = try parseFunctionSectionData(allocator, section_reader);
                    try section_list.append(section);
                },
                .table => {
                    std.debug.print("Table Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    const section = try parseTableSectionData(allocator, section_reader);
                    try section_list.append(section);
                },
                .memory => {
                    std.debug.print("Memory Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    const section = try parseMemorySectionData(allocator, section_reader);
                    try section_list.append(section);
                },
                .global => {
                    std.debug.print("Global Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    const section = try parseGlobalSectionData(allocator, section_reader);
                    try section_list.append(section);
                },
                .@"export" => {
                    std.debug.print("Export Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    const section = try parseExportSectionData(allocator, section_reader);
                    try section_list.append(section);
                },
                .start => {
                    std.debug.print("Start Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    const section = try parseStartSectionData(allocator, section_reader);
                    try section_list.append(section);
                },
                .element => {
                    std.debug.print("Element Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    const section = try parseElementSectionData(allocator, section_reader);
                    try section_list.append(section);
                },
                .code => {
                    std.debug.print("Code Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    const section = try parseCodeSectionData(allocator, section_reader);
                    try section_list.append(section);
                },
                .data => {
                    std.debug.print("Data Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    const section = try parseDataSectionData(allocator, section_reader);
                    try section_list.append(section);
                },
            }
        }

        return Module{
            .allocator = allocator,
            .sections = try section_list.toOwnedSlice(),
        };
    }

    pub fn fromPath(allocator: std.mem.Allocator, path: []const u8) !Module {
        std.debug.print("\n\nLoading module from path: {s}\n", .{path});

        var file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
        defer file.close();

        const slice = try file.readToEndAlloc(allocator, std.math.maxInt(usize));
        return try Module.fromSlice(allocator, slice);
    }

    pub fn deinit(self: Module) void {
        for (self.sections) |section| {
            switch (section) {
                .custom => {
                    self.allocator.free(section.custom.name);
                    self.allocator.free(section.custom.data);
                },
                .type => {
                    for (section.type.types) |@"type"| {
                        self.allocator.free(@"type".params);
                        self.allocator.free(@"type".returns);
                    }
                    self.allocator.free(section.type.types);
                },
                .import => {
                    for (section.import.imports) |import| {
                        self.allocator.free(import.module_name);
                        self.allocator.free(import.import_name);
                    }
                    self.allocator.free(section.import.imports);
                },
                .function => {
                    self.allocator.free(section.function.type_indicies);
                },
                .table => {
                    self.allocator.free(section.table.tables);
                },
                .memory => {
                    self.allocator.free(section.memory.memories);
                },
                .global => {
                    for (section.global.globals) |global| {
                        self.allocator.free(global.init);
                    }
                    self.allocator.free(section.global.globals);
                },
                .@"export" => {
                    self.allocator.free(section.@"export".exports);
                },
                .start => {
                    // nothing to free
                },
                .element => {
                    // for (section.element.segments) |segment| {
                    //     self.allocator.free(segment.offset);
                    //     self.allocator.free(segment.init);
                    // }
                    self.allocator.free(section.element.segments);
                },
                .code => {
                    // for (section.code.bodies) |body| {
                    //     for (body.locals) |local| {
                    //         self.allocator.free(local.type);
                    //     }
                    //     self.allocator.free(body.locals);
                    //     self.allocator.free(body.code);
                    // }
                    self.allocator.free(section.code.bodies);
                },
                .data => {
                    // for (section.data.segments) |segment| {
                    //     self.allocator.free(segment.offset);
                    //     self.allocator.free(segment.init);
                    // }
                    self.allocator.free(section.data.segments);
                },
            }
        }

        self.allocator.free(self.sections);
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

    fn createSectionReader(allocator: std.mem.Allocator, module_reader: anytype) SectionReader {
        const section_size = std.leb.readULEB128(usize, module_reader) catch unreachable;
        const section_bytes = allocator.alloc(u8, section_size) catch unreachable;
        _ = module_reader.readAll(section_bytes) catch unreachable;
        var section_buffer = std.io.fixedBufferStream(section_bytes);

        return section_buffer.reader();
    }

    fn parseCustomSectionData(allocator: std.mem.Allocator, reader: SectionReader) !Section {
        _ = reader;
        _ = allocator;
        return Section{
            .custom = .{
                .name = "",
                .data = undefined,
            },
        };
    }

    fn parseTypeSectionData(allocator: std.mem.Allocator, reader: SectionReader) !Section {
        const count = try std.leb.readULEB128(usize, reader);
        std.debug.print("    Type count: {}\n", .{count});

        var type_data_list = std.ArrayList(TypeSectionData).init(allocator);
        for (0..count) |_| {
            try reader.skipBytes(1, .{}); // always 0x60 - function signature

            const params_count = try std.leb.readULEB128(usize, reader);
            const params_bytes = try allocator.alloc(u8, params_count);
            defer allocator.free(params_bytes);
            _ = try reader.readAll(params_bytes);

            const returns_count = try std.leb.readULEB128(usize, reader);
            const returns_bytes = try allocator.alloc(u8, returns_count);
            defer allocator.free(returns_bytes);
            _ = try reader.readAll(returns_bytes);

            var params_list = std.ArrayList(ValueType).init(allocator);
            for (params_bytes) |param| {
                try params_list.append(@enumFromInt(param));
            }

            var returns_list = std.ArrayList(ValueType).init(allocator);
            for (returns_bytes) |returns_byte| {
                try returns_list.append(@enumFromInt(returns_byte));
            }

            try type_data_list.append(TypeSectionData{
                .params = try params_list.toOwnedSlice(),
                .returns = try returns_list.toOwnedSlice(),
            });
        }

        return Section{
            .type = .{ .types = try type_data_list.toOwnedSlice() },
        };
    }

    fn parseImportSectionData(allocator: std.mem.Allocator, reader: SectionReader) !Section {
        const count = try std.leb.readULEB128(usize, reader);
        std.debug.print("    Import count: {}\n", .{count});

        var import_data_list = std.ArrayList(ImportSectionData).init(allocator);
        for (0..count) |_| {
            const module_name_length = try std.leb.readULEB128(usize, reader);
            const module_name_bytes = try allocator.alloc(u8, module_name_length);
            _ = try reader.readAll(module_name_bytes);

            const import_name_length = try std.leb.readULEB128(usize, reader);
            const import_name_bytes = try allocator.alloc(u8, import_name_length);
            _ = try reader.readAll(import_name_bytes);

            const import_type: ImportExportType = @enumFromInt(try reader.readByte());
            switch (import_type) {
                .function => {
                    const type_index = try std.leb.readULEB128(usize, reader);

                    try import_data_list.append(ImportSectionData{
                        .module_name = module_name_bytes,
                        .import_name = import_name_bytes,
                        .description = .{
                            .function = .{
                                .type_index = type_index,
                            },
                        },
                    });
                },
                .table => {
                    unreachable;
                },
                .memory => {
                    unreachable;
                },
                .global => {
                    unreachable;
                },
            }
        }

        return Section{
            .import = .{ .imports = try import_data_list.toOwnedSlice() },
        };
    }

    fn parseFunctionSectionData(allocator: std.mem.Allocator, reader: SectionReader) !Section {
        const count = try std.leb.readULEB128(usize, reader);
        std.debug.print("    Function count: {}\n", .{count});

        const type_indicies_bytes = try allocator.alloc(u8, count);
        defer allocator.free(type_indicies_bytes);
        _ = try reader.readAll(type_indicies_bytes);

        var type_indicies_list = std.ArrayList(usize).init(allocator);
        for (type_indicies_bytes) |byte| {
            try type_indicies_list.append(byte);
        }

        return Section{
            .function = .{ .type_indicies = try type_indicies_list.toOwnedSlice() },
        };
    }

    fn parseTableSectionData(allocator: std.mem.Allocator, reader: SectionReader) !Section {
        const count = try std.leb.readULEB128(usize, reader);
        std.debug.print("    Table count: {}\n", .{count});

        var table_data_list = std.ArrayList(TableSectionData).init(allocator);
        for (0..count) |_| {
            const table_type: ValueType = @enumFromInt(try reader.readByte());
            const table_min = try std.leb.readULEB128(usize, reader);
            const table_max = try std.leb.readULEB128(usize, reader);

            try table_data_list.append(TableSectionData{
                .type = table_type,
                .limits = .{
                    .min = table_min,
                    .max = table_max,
                },
            });
        }

        return Section{ .table = .{
            .tables = try table_data_list.toOwnedSlice(),
        } };
    }

    fn parseMemorySectionData(allocator: std.mem.Allocator, reader: SectionReader) !Section {
        const count = try std.leb.readULEB128(usize, reader);
        std.debug.print("    Memory count: {}\n", .{count});

        var memory_data_list = std.ArrayList(MemorySectionData).init(allocator);
        for (0..count) |_| {
            const memory_has_max = try reader.readByte();
            const memory_min = try std.leb.readULEB128(usize, reader);
            var memory_max: usize = 0;
            if (memory_has_max > 0) {
                memory_max = try std.leb.readULEB128(usize, reader);
            }

            try memory_data_list.append(MemorySectionData{
                .limits = .{
                    .has_max = (memory_has_max > 0),
                    .min = memory_min,
                    .max = memory_max,
                },
            });
        }

        return Section{ .memory = .{
            .memories = try memory_data_list.toOwnedSlice(),
        } };
    }

    fn parseGlobalSectionData(allocator: std.mem.Allocator, reader: SectionReader) !Section {
        const count = try std.leb.readULEB128(usize, reader);
        std.debug.print("    Global count: {}\n", .{count});

        var global_data_list = std.ArrayList(GlobalSectionData).init(allocator);
        for (0..count) |_| {
            const global_type: ValueType = @enumFromInt(try reader.readByte());
            const global_mutability = (try reader.readByte() > 0);
            const global_init = try reader.readUntilDelimiterAlloc(allocator, 0x0B, std.math.maxInt(usize));

            try global_data_list.append(GlobalSectionData{
                .type = global_type,
                .mutability = global_mutability,
                .init = try std.mem.concat(
                    allocator,
                    u8,
                    &[_][]const u8{ global_init, "\x0B" }, // zig concat is a bit """different"""
                ),
            });
        }

        return Section{ .global = .{
            .globals = try global_data_list.toOwnedSlice(),
        } };
    }

    fn parseExportSectionData(allocator: std.mem.Allocator, reader: SectionReader) !Section {
        const count = try std.leb.readULEB128(usize, reader);
        std.debug.print("    Export count: {}\n", .{count});

        var export_data_list = std.ArrayList(ExportSectionData).init(allocator);
        for (0..count) |_| {
            const export_name_length = try std.leb.readULEB128(usize, reader);
            const export_name_bytes = try allocator.alloc(u8, export_name_length);
            _ = try reader.readAll(export_name_bytes);

            const export_type: ImportExportType = @enumFromInt(try reader.readByte());

            switch (export_type) {
                .function => {
                    try export_data_list.append(ExportSectionData{
                        .name = export_name_bytes,
                        .description = .{
                            .function = try std.leb.readULEB128(usize, reader),
                        },
                    });
                },
                .table => {
                    try export_data_list.append(ExportSectionData{
                        .name = export_name_bytes,
                        .description = .{
                            .table = try std.leb.readULEB128(usize, reader),
                        },
                    });
                },
                .memory => {
                    try export_data_list.append(ExportSectionData{
                        .name = export_name_bytes,
                        .description = .{
                            .memory = try std.leb.readULEB128(usize, reader),
                        },
                    });
                },
                .global => {
                    try export_data_list.append(ExportSectionData{
                        .name = export_name_bytes,
                        .description = .{
                            .global = try std.leb.readULEB128(usize, reader),
                        },
                    });
                },
            }
        }

        return Section{ .@"export" = .{
            .exports = try export_data_list.toOwnedSlice(),
        } };
    }

    fn parseStartSectionData(_: std.mem.Allocator, reader: SectionReader) !Section {
        return Section{ .start = .{ .function_index = try std.leb.readULEB128(usize, reader) } };
    }

    // hmmm - need more research for this, kinda komplex
    fn parseElementSectionData(allocator: std.mem.Allocator, reader: SectionReader) !Section {
        const count = try std.leb.readULEB128(usize, reader);
        std.debug.print("    Element count: {}\n", .{count});

        var element_data_list = std.ArrayList(ElementSectionData).init(allocator);
        for (0..count) |_| {}

        return Section{ .element = .{
            .segments = try element_data_list.toOwnedSlice(),
        } };
    }

    fn parseCodeSectionData(allocator: std.mem.Allocator, reader: SectionReader) !Section {
        const count = try std.leb.readULEB128(usize, reader);
        std.debug.print("    Code count: {}\n", .{count});

        var code_data_list = std.ArrayList(CodeSectionData).init(allocator);
        for (0..count) |_| {}

        std.debug.print("        code_data_list: {any}\n", .{code_data_list.items});

        return Section{ .code = .{
            .bodies = try code_data_list.toOwnedSlice(),
        } };
    }

    fn parseDataSectionData(allocator: std.mem.Allocator, reader: SectionReader) !Section {
        const count = try std.leb.readULEB128(usize, reader);
        std.debug.print("    Data count: {}\n", .{count});

        var data_list = std.ArrayList(CodeSectionData).init(allocator);
        for (0..count) |_| {}

        std.debug.print("        data_list: {any}\n", .{data_list.items});

        return Section{ .code = .{
            .bodies = try data_list.toOwnedSlice(),
        } };
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
        type_indicies: []const usize,
    },
    table: struct {
        tables: []const TableSectionData,
    },
    memory: struct {
        memories: []const MemorySectionData,
    },
    global: struct {
        globals: []const GlobalSectionData,
    },
    @"export": struct {
        exports: []const ExportSectionData,
    },
    start: struct {
        function_index: usize,
    },
    element: struct {
        segments: []const ElementSectionData,
    },
    code: struct {
        bodies: []const CodeSectionData,
    },
    data: struct {
        segments: []const DataSectionData,
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

const ImportExportType = enum(u8) {
    // zig fmt: off
    function    = 0x00,
    table       = 0x01,
    memory      = 0x02,
    global      = 0x03,
    // zig fmt: on
};

const Limits = struct {
    has_max: bool = true,
    min: usize,
    max: usize,
};

const TypeSectionData = struct {
    params: []const ValueType,
    returns: []const ValueType,
};

const ImportSectionData = struct {
    module_name: []const u8,
    import_name: []const u8,
    description: union(ImportExportType) {
        function: struct {
            type_index: usize,
        },
        table: struct {
            type: ValueType,
            limits: Limits,
        },
        memory: struct {
            limits: Limits,
        },
        global: struct {
            type: ValueType,
            mutability: bool,
        },
    },
};

const TableSectionData = struct {
    type: ValueType,
    limits: Limits,
};

const MemorySectionData = struct {
    limits: Limits,
};

const CodeLocal = struct {
    count: usize,
    type: ValueType,
};

const GlobalSectionData = struct {
    type: ValueType,
    mutability: bool,
    init: []const u8,
};

const ExportSectionData = struct {
    name: []const u8,
    description: union(ImportExportType) {
        function: usize,
        table: usize,
        memory: usize,
        global: usize,
    },
};

const ElementSectionData = struct {
    index: usize,
    offset: []const u8,
    init: []const u8,
};

const CodeSectionData = struct {
    locals: []const CodeLocal,
    code: []const u8,
};

const DataSectionData = struct {
    index: usize,
    offset: []const u8,
    init: []const u8,
};
