const std = @import("std");
const print = std.debug.print;

const ModuleReader = std.io.FixedBufferStream([]const u8).Reader;
const SectionReader = std.io.FixedBufferStream([]u8).Reader;

pub const Module = struct {
    allocator: std.mem.Allocator,
    reader: std.io.FixedBufferStream([]const u8).Reader,
    sections: Sections,

    pub fn fromPath(allocator: std.mem.Allocator, module_path: []const u8) !Module {
        var file = try std.fs.cwd().openFile(module_path, .{ .mode = .read_only });
        defer file.close();

        const module_slice = try file.readToEndAlloc(allocator, std.math.maxInt(u32));
        return try Module.fromSlice(allocator, module_slice);
    }

    pub fn fromSlice(allocator: std.mem.Allocator, module_slice: []const u8) !Module {
        var module_buffer = std.io.fixedBufferStream(module_slice);
        const module_reader = module_buffer.reader();

        return try Module.fromReader(allocator, module_reader);
    }

    pub fn fromReader(allocator: std.mem.Allocator, module_reader: ModuleReader) !Module {
        try checkMagic(module_reader);
        try checkVersion(module_reader);

        var sections = std.mem.zeroInit(Sections, .{});

        while (true) {
            const section_id: SectionID = @enumFromInt(module_reader.readByte() catch break);

            switch (section_id) {
                .custom => {
                    print("Custom Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    sections.custom = try parseCustomSection(allocator, section_reader);
                },
                .type => {
                    print("Type Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    sections.type = try parseTypeSection(allocator, section_reader);
                },
                .import => {
                    print("Import Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    sections.import = try parseImportSection(allocator, section_reader);
                },
                .function => {
                    print("Function Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    sections.function = try parseFunctionSection(allocator, section_reader);
                },
                .table => {
                    print("Table Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    sections.table = try parseTableSection(allocator, section_reader);
                },
                .memory => {
                    print("Memory Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    sections.memory = try parseMemorySection(allocator, section_reader);
                },
                .global => {
                    print("Global Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    sections.global = try parseGlobalSection(allocator, section_reader);
                },
                .@"export" => {
                    print("Export Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    sections.@"export" = try parseExportSection(allocator, section_reader);
                },
                .start => {
                    print("Start Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    sections.start = try parseStartSection(allocator, section_reader);
                },
                .element => {
                    print("Element Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    sections.element = try parseElementSection(allocator, section_reader);
                },
                .code => {
                    print("Code Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    sections.code = try parseCodeSection(allocator, section_reader);
                },
                .data => {
                    print("Data Section\n", .{});
                    const section_reader = createSectionReader(allocator, module_reader);
                    sections.data = try parseDataSection(allocator, section_reader);
                },
            }
        }

        return Module{
            .allocator = allocator,
            .reader = module_reader,
            .sections = sections,
        };
    }

    pub fn deinit(self: Module) void {
        _ = self;
    }

    fn checkMagic(reader: ModuleReader) !void {
        var magic: [4]u8 = undefined;
        _ = try reader.readAll(&magic);
        if (!std.mem.eql(u8, &magic, &[4]u8{ 0x00, 0x61, 0x73, 0x6D })) {
            return error.InvalidMagicNumber;
        }
    }

    fn checkVersion(reader: ModuleReader) !void {
        var version: [4]u8 = undefined;
        _ = try reader.readAll(&version);
        print("Version: {}.{}.{}.{}\n", .{ version[0], version[1], version[2], version[3] });
        if (!std.mem.eql(u8, &version, &[4]u8{ 0x01, 0x00, 0x00, 0x00 })) {
            return error.UnsupportedVersion;
        }
    }

    fn createSectionReader(allocator: std.mem.Allocator, module_reader: ModuleReader) SectionReader {
        // TODO: !!! switch to using sub-slices instead of allocating new memory and leaking it !!!
        const section_size = std.leb.readULEB128(usize, module_reader) catch unreachable;
        const section_bytes = allocator.alloc(u8, section_size) catch unreachable;
        _ = module_reader.readAll(section_bytes) catch unreachable;
        var section_buffer = std.io.fixedBufferStream(section_bytes);

        return section_buffer.reader();
    }

    fn parseCustomSection(allocator: std.mem.Allocator, reader: SectionReader) !CustomSection {
        const data = try reader.readAllAlloc(allocator, std.math.maxInt(u32));
        _ = data;

        return CustomSection{
            .map = std.StringHashMap([]const u8).init(allocator),
        };
    }

    fn parseTypeSection(allocator: std.mem.Allocator, reader: SectionReader) !TypeSection {
        const count = try std.leb.readULEB128(u32, reader);
        print("    Type count: {}\n", .{count});

        var segments = try allocator.alloc(TypeSectionSegment, count);
        for (0..count) |segment_index| {
            try reader.skipBytes(1, .{}); // always 0x60 - function signature

            const params_count = try std.leb.readULEB128(u32, reader);
            const params_bytes = try allocator.alloc(u8, params_count);
            defer allocator.free(params_bytes);
            _ = try reader.readAll(params_bytes);

            var params = try allocator.alloc(ValueType, params_count);
            for (0..params_count) |params_index| {
                params[params_index] = @enumFromInt(params_bytes[params_index]);
            }

            const returns_count = try std.leb.readULEB128(u32, reader);
            const returns_bytes = try allocator.alloc(u8, returns_count);
            defer allocator.free(returns_bytes);
            _ = try reader.readAll(returns_bytes);

            var returns = try allocator.alloc(ValueType, returns_count);
            for (0..returns_count) |returns_index| {
                returns[returns_index] = @enumFromInt(returns_bytes[returns_index]);
            }

            segments[segment_index] = TypeSectionSegment{
                .params = params,
                .returns = returns,
            };
        }

        return TypeSection{
            .segments = segments,
        };
    }

    fn parseImportSection(allocator: std.mem.Allocator, reader: SectionReader) !ImportSection {
        const count = try std.leb.readULEB128(u32, reader);
        print("    Import count: {}\n", .{count});

        var segments = try allocator.alloc(ImportSectionSegemnt, count);
        for (0..count) |segment_index| {
            const module_name_length = try std.leb.readULEB128(u32, reader);
            const module_name_bytes = try allocator.alloc(u8, module_name_length);
            _ = try reader.readAll(module_name_bytes);

            const import_name_length = try std.leb.readULEB128(u32, reader);
            const import_name_bytes = try allocator.alloc(u8, import_name_length);
            _ = try reader.readAll(import_name_bytes);

            const import_type: ImportExportType = @enumFromInt(try reader.readByte());
            switch (import_type) {
                .function => {
                    const type_index = try std.leb.readULEB128(u32, reader);

                    segments[segment_index] = ImportSectionSegemnt{
                        .module_name = module_name_bytes,
                        .import_name = import_name_bytes,
                        .description = .{
                            .function = .{
                                .type_index = type_index,
                            },
                        },
                    };
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

        return ImportSection{
            .segments = segments,
        };
    }

    fn parseFunctionSection(allocator: std.mem.Allocator, reader: SectionReader) !FunctionSection {
        const count = try std.leb.readULEB128(u32, reader);
        print("    Function count: {}\n", .{count});

        const type_indicies_bytes = try allocator.alloc(u8, count);
        defer allocator.free(type_indicies_bytes);
        _ = try reader.readAll(type_indicies_bytes);

        var type_indicies = try allocator.alloc(u32, count);
        for (0..count) |type_index| {
            type_indicies[type_index] = type_indicies_bytes[type_index];
        }

        return FunctionSection{
            .type_indicies = type_indicies,
        };
    }

    fn parseTableSection(allocator: std.mem.Allocator, reader: SectionReader) !TableSection {
        const count = try std.leb.readULEB128(u32, reader);
        print("    Table count: {}\n", .{count});

        var segments = try allocator.alloc(TableSectionSegments, count);
        for (0..count) |segment_index| {
            const table_type: ValueType = @enumFromInt(try reader.readByte());
            const table_min = try std.leb.readULEB128(u32, reader);
            const table_max = try std.leb.readULEB128(u32, reader);

            segments[segment_index] = TableSectionSegments{
                .type = table_type,
                .limits = .{
                    .min = table_min,
                    .max = table_max,
                },
            };
        }

        return TableSection{
            .segments = segments,
        };
    }

    fn parseMemorySection(allocator: std.mem.Allocator, reader: SectionReader) !MemorySection {
        const count = try std.leb.readULEB128(u32, reader);
        print("    Memory count: {}\n", .{count});

        var segments = try allocator.alloc(MemorySectionSegment, count);
        for (0..count) |segment_index| {
            const memory_has_max = try reader.readByte();
            const memory_min = try std.leb.readULEB128(u32, reader);
            var memory_max: u32 = 0;
            if (memory_has_max > 0) {
                memory_max = try std.leb.readULEB128(u32, reader);
            }

            segments[segment_index] = MemorySectionSegment{
                .limits = .{
                    .has_max = (memory_has_max > 0),
                    .min = memory_min,
                    .max = memory_max,
                },
            };
        }

        return MemorySection{
            .segments = segments,
        };
    }

    fn parseGlobalSection(allocator: std.mem.Allocator, reader: SectionReader) !GlobalSection {
        const count = try std.leb.readULEB128(u32, reader);
        print("    Global count: {}\n", .{count});

        var segments = try allocator.alloc(GlobalSectionSegment, count);
        for (0..count) |segment_index| {
            const global_type: ValueType = @enumFromInt(try reader.readByte());
            const global_mutability = (try reader.readByte() > 0);
            const global_init = try reader.readUntilDelimiterAlloc(allocator, 0x0B, std.math.maxInt(usize));

            segments[segment_index] = GlobalSectionSegment{
                .type = global_type,
                .mutability = global_mutability,
                .init = try std.mem.concat(
                    allocator,
                    u8,
                    &[_][]const u8{ global_init, "\x0B" }, // zig concat is a bit """different"""
                ),
            };
        }

        return GlobalSection{
            .segments = segments,
        };
    }

    fn parseExportSection(allocator: std.mem.Allocator, reader: SectionReader) !ExportSection {
        const count = try std.leb.readULEB128(u32, reader);
        print("    Export count: {}\n", .{count});

        var segments = try allocator.alloc(ExportSectionSegment, count);
        for (0..count) |segment_index| {
            const export_name_length = try std.leb.readULEB128(u32, reader);
            const export_name_bytes = try allocator.alloc(u8, export_name_length);
            _ = try reader.readAll(export_name_bytes);
            const export_type: ImportExportType = @enumFromInt(try reader.readByte());

            switch (export_type) {
                .function => {
                    segments[segment_index] = ExportSectionSegment{
                        .name = export_name_bytes,
                        .description = .{
                            .function = try std.leb.readULEB128(u32, reader),
                        },
                    };
                },
                .table => {
                    segments[segment_index] = ExportSectionSegment{
                        .name = export_name_bytes,
                        .description = .{
                            .table = try std.leb.readULEB128(u32, reader),
                        },
                    };
                },
                .memory => {
                    segments[segment_index] = ExportSectionSegment{
                        .name = export_name_bytes,
                        .description = .{
                            .memory = try std.leb.readULEB128(u32, reader),
                        },
                    };
                },
                .global => {
                    segments[segment_index] = ExportSectionSegment{
                        .name = export_name_bytes,
                        .description = .{
                            .global = try std.leb.readULEB128(u32, reader),
                        },
                    };
                },
            }
        }

        return ExportSection{
            .segments = segments,
        };
    }

    fn parseStartSection(_: std.mem.Allocator, reader: SectionReader) !StartSection {
        return StartSection{ .function_index = try std.leb.readULEB128(u32, reader) };
    }

    fn parseElementSection(allocator: std.mem.Allocator, reader: SectionReader) !ElementSection {
        const count = try std.leb.readULEB128(u32, reader);
        print("    Element count: {}\n", .{count});

        var segments = try allocator.alloc(ElementSectionSegment, count);
        for (0..count) |segment_index| {
            const index = try std.leb.readULEB128(u32, reader);
            const offset = try reader.readUntilDelimiterAlloc(allocator, 0x0B, std.math.maxInt(u32));
            const element_count = try std.leb.readULEB128(u32, reader);

            var elements = try allocator.alloc(u32, element_count);
            for (0..element_count) |ii| {
                elements[ii] = try std.leb.readULEB128(u32, reader);
            }
            segments[segment_index] = ElementSectionSegment{
                .index = index,
                .offset = try std.mem.concat(allocator, u8, &[_][]const u8{ offset, "\x0B" }),
                .elements = elements,
            };
        }

        return ElementSection{
            .segments = segments,
        };
    }

    fn parseCodeSection(allocator: std.mem.Allocator, reader: SectionReader) !CodeSection {
        const count = try std.leb.readULEB128(u32, reader);
        print("    Code count: {}\n", .{count});

        var segments = try allocator.alloc(CodeSectionSegment, count);
        for (0..count) |segment_index| {
            const body_size = try std.leb.readULEB128(u32, reader); // body_size
            const reader_start = reader.context.pos;

            const local_count = try std.leb.readULEB128(u32, reader);
            var locals = try allocator.alloc(CodeLocal, local_count);
            for (0..local_count) |local_index| {
                locals[local_index] = CodeLocal{
                    .count = try std.leb.readULEB128(u32, reader),
                    .type = @enumFromInt(try reader.readByte()),
                };
            }
            const reader_count = reader.context.pos - reader_start;
            const code = try allocator.alloc(u8, body_size - reader_count);
            _ = try reader.readAll(code);

            // print("        Code: {any}\n", .{code});

            segments[segment_index] = CodeSectionSegment{
                .locals = locals,
                .code = code,
            };
        }

        return CodeSection{
            .segments = segments,
        };
    }

    fn parseDataSection(allocator: std.mem.Allocator, reader: SectionReader) !DataSection {
        const count = try std.leb.readULEB128(u32, reader);
        print("    Data count: {}\n", .{count});

        var segments = try allocator.alloc(DataSectionSegment, count);
        for (0..count) |segment_index| {
            const index = try std.leb.readULEB128(u32, reader);
            const offset = try reader.readUntilDelimiterAlloc(allocator, 0x0B, std.math.maxInt(u32));
            const size = try std.leb.readULEB128(u32, reader);
            const data = try allocator.alloc(u8, size);
            _ = try reader.readAll(data);

            // print("        Data: {any}\n", .{data});

            segments[segment_index] = DataSectionSegment{
                .index = index,
                .offset = offset,
                .data = data,
            };
        }

        return DataSection{
            .segments = segments,
        };
    }
};

const Sections = struct {
    custom: ?CustomSection,
    type: ?TypeSection,
    import: ?ImportSection,
    function: ?FunctionSection,
    table: ?TableSection,
    memory: ?MemorySection,
    global: ?GlobalSection,
    @"export": ?ExportSection,
    start: ?StartSection,
    element: ?ElementSection,
    code: ?CodeSection,
    data: ?DataSection,
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
    min: u32,
    max: u32,
};

const CodeLocal = struct {
    count: u32,
    type: ValueType,
};

const CustomSection = struct {
    map: std.StringHashMap([]const u8),
};

const TypeSectionSegment = struct {
    params: []const ValueType,
    returns: []const ValueType,
};

const TypeSection = struct {
    segments: []const TypeSectionSegment,
};

const ImportSectionSegemnt = struct {
    module_name: []const u8,
    import_name: []const u8,
    description: union(ImportExportType) {
        function: struct {
            type_index: u32,
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

const ImportSection = struct {
    segments: []const ImportSectionSegemnt,
};

const FunctionSection = struct {
    type_indicies: []const u32,
};

const TableSectionSegments = struct {
    type: ValueType,
    limits: Limits,
};

const TableSection = struct {
    segments: []const TableSectionSegments,
};

const MemorySectionSegment = struct {
    limits: Limits,
};

const MemorySection = struct {
    segments: []const MemorySectionSegment,
};

const GlobalSectionSegment = struct {
    type: ValueType,
    mutability: bool,
    init: []const u8,
};

const GlobalSection = struct {
    segments: []const GlobalSectionSegment,
};

const ExportSectionSegment = struct {
    name: []const u8,
    description: union(ImportExportType) {
        function: u32,
        table: u32,
        memory: u32,
        global: u32,
    },
};

const ExportSection = struct {
    segments: []const ExportSectionSegment,
};

const StartSection = struct {
    function_index: u32,
};

const ElementSectionSegment = struct {
    index: u32,
    offset: []const u8,
    elements: []const u32,
};

const ElementSection = struct {
    segments: []const ElementSectionSegment,
};

const CodeSectionSegment = struct {
    locals: []const CodeLocal,
    code: []const u8,
};

const CodeSection = struct {
    segments: []const CodeSectionSegment,
};

const DataSectionSegment = struct {
    index: u32,
    offset: []const u8,
    data: []const u8,
};

const DataSection = struct {
    segments: []const DataSectionSegment,
};
