pub const OPCode = enum(u32) {
    // zig fmt: off
    @"unreachable"          = 0x00,
    nop                     = 0x01,
    block                   = 0x02,
    loop                    = 0x04,
    @"if"                   = 0x04,
    @"else"                 = 0x05,
    @"try"                  = 0x06,
    @"catch"                = 0x07,
    throw                   = 0x08,
    rethrow                 = 0x09,
    end                     = 0x0B,
    br                      = 0x0C,
    br_if                   = 0x0D,
    br_table                = 0x0E,
    @"return"               = 0x0F,
    call                    = 0x10,
    call_indirect           = 0x11,
    return_call             = 0x12,
    return_call_indirect    = 0x13,
    call_ref                = 0x14,
    return_call_ref         = 0x15,
    delegate                = 0x18,
    catch_all               = 0x19,
    drop                    = 0x1A,
    select                  = 0x1B,
    select_with_type        = 0x1C,
    //
    @"local.get"            = 0x20,
    @"local.set"            = 0x21,
    @"local.tee"            = 0x22,
    @"global.get"           = 0x23,
    @"global.set"           = 0x24,
    @"table.get"            = 0x25,
    @"table.set"            = 0x26,
    @"i32.load"             = 0x28,
    @"i64.load"             = 0x29,
    @"f32.load"             = 0x2A,
    @"f64.load"             = 0x2B,
    @"i32.load8_s"          = 0x2C,
    @"i32.load8_u"          = 0x2D,
    @"i32.load16_s"         = 0x2E,
    @"i32.load16_u"         = 0x2F,
    @"i64.load8_s"          = 0x30,
    @"i64.load8_u"          = 0x31,
    @"i64.load16_s"         = 0x32,
    @"i64.load16_u"         = 0x33,
    @"i64.load32_s"         = 0x34,
    @"i64.load32_u"         = 0x35,
    //
    @"i32.store"            = 0x36,
    @"i64.store"            = 0x37,
    @"f32.store"            = 0x38,
    @"f64.store"            = 0x39,
    @"i32.store8"           = 0x3A,
    @"i32.store16"          = 0x3B,
    @"i64.store8"           = 0x3C,
    @"i64.store16"          = 0x3D,
    @"i64.store32"          = 0x3E,
    @"memory.size"          = 0x3F,
    @"memory.grow"          = 0x40,
    @"i32.const"            = 0x41,
    @"i64.const"            = 0x42,
    @"f32.const"            = 0x43,
    @"f64.const"            = 0x44,
    //
    @"i32.eqz"              = 0x45,
    @"i32.eq"               = 0x46,
    @"i32.ne"               = 0x47,
    @"i32.lt_s"             = 0x48,
    @"i32.lt_u"             = 0x49,
    @"i32.gt_s"             = 0x4A,
    @"i32.gt_u"             = 0x4B,
    @"i32.le_s"             = 0x4C,
    @"i32.le_u"             = 0x4D,
    @"i32.ge_s"             = 0x4E,
    @"i32.ge_u"             = 0x4F,
    //
    @"i64.eqz"              = 0x50,
    @"i64.eq"               = 0x51,
    @"i64.ne"               = 0x52,
    @"i64.lt_s"             = 0x53,
    @"i64.lt_u"             = 0x54,
    @"i64.gt_s"             = 0x55,
    @"i64.gt_u"             = 0x56,
    @"i64.le_s"             = 0x57,
    @"i64.le_u"             = 0x58,
    @"i64.ge_s"             = 0x59,
    @"i64.ge_u"             = 0x5A,
    //
    @"f32.eq"               = 0x5B,
    @"f32.ne"               = 0x5C,
    @"f32.lt"               = 0x5D,
    @"f32.gt"               = 0x5E,
    @"f32.le"               = 0x5F,
    @"f32.ge"               = 0x60,
    @"f64.eq"               = 0x61,
    @"f64.ne"               = 0x62,
    @"f64.lt"               = 0x63,
    @"f64.gt"               = 0x64,
    @"f64.le"               = 0x65,
    @"f64.ge"               = 0x66,
    //
    @"i32.clz"              = 0x67,
    @"i32.ctz"              = 0x68,
    @"i32.popcnt"           = 0x69,
    @"i32.add"              = 0x6A,
    @"i32.sub"              = 0x6B,
    @"i32.mul"              = 0x6C,
    @"i32.div_s"            = 0x6D,
    @"i32.div_u"            = 0x6E,
    @"i32.rem_s"            = 0x6F,
    @"i32.rem_u"            = 0x70,
    @"i32.and"              = 0x71,
    @"i32.or"               = 0x72,
    @"i32.xor"              = 0x73,
    @"i32.shl"              = 0x74,
    @"i32.shr_s"            = 0x75,
    @"i32.shr_u"            = 0x76,
    @"i32.rotl"             = 0x77,
    @"i32.rotr"             = 0x78,
    //
    @"i64.clz"              = 0x79,
    @"i64.ctz"              = 0x7A,
    @"i64.popcnt"           = 0x7B,
    @"i64.add"              = 0x7C,
    @"i64.sub"              = 0x7D,
    @"i64.mul"              = 0x7E,
    @"i64.div_s"            = 0x7F,
    @"i64.div_u"            = 0x80,
    @"i64.rem_s"            = 0x81,
    @"i64.rem_u"            = 0x82,
    @"i64.and"              = 0x83,
    @"i64.or"               = 0x84,
    @"i64.xor"              = 0x85,
    @"i64.shl"              = 0x86,
    @"i64.shr_s"            = 0x87,
    @"i64.shr_u"            = 0x88,
    @"i64.rotl"             = 0x89,
    @"i64.rotr"             = 0x8A,
    //
    @"f32.abs"              = 0x8B,
    @"f32.neg"              = 0x8C,
    @"f32.ceil"             = 0x8D,
    @"f32.floor"            = 0x8E,
    @"f32.trunc"            = 0x8F,
    @"f32.nearest"          = 0x90,
    @"f32.sqrt"             = 0x91,
    @"f32.add"              = 0x92,
    @"f32.sub"              = 0x93,
    @"f32.mul"              = 0x94,
    @"f32.div"              = 0x95,
    @"f32.min"              = 0x96,
    @"f32.max"              = 0x97,
    @"f32.copysign"         = 0x98,
    //
    @"f64.abs"              = 0x99,
    @"f64.neg"              = 0x9A,
    @"f64.ceil"             = 0x9B,
    @"f64.floor"            = 0x9C,
    @"f64.trunc"            = 0x9D,
    @"f64.nearest"          = 0x9E,
    @"f64.sqrt"             = 0x9F,
    @"f64.add"              = 0xA0,
    @"f64.sub"              = 0xA1,
    @"f64.mul"              = 0xA2,
    @"f64.div"              = 0xA3,
    @"f64.min"              = 0xA4,
    @"f64.max"              = 0xA5,
    @"f64.copysign"         = 0xA6,
    //
    @"i32.wrap_i64"         = 0xA7,
    @"i32.trunc_f32_s"      = 0xA8,
    @"i32.trunc_f32_u"      = 0xA9,
    @"i32.trunc_f64_s"      = 0xAA,
    @"i32.trunc_f64_u"      = 0xAB,
    //
    @"i64.extend_i32_s"     = 0xAC,
    @"i64.extend_i32_u"     = 0xAD,
    @"i64.trunc_f32_s"      = 0xAE,
    @"i64.trunc_f32_u"      = 0xAF,
    @"i64.trunc_f64_s"      = 0xB0,
    @"i64.trunc_f64_u"      = 0xB1,
    //
    @"f32.convert_i32_s"    = 0xB2,
    @"f32.convert_i32_u"    = 0xB3,
    @"f32.convert_i64_s"    = 0xB4,
    @"f32.convert_i64_u"    = 0xB5,
    @"f32.demote_f64"       = 0xB6,
    //
    @"f64.convert_i32_s"    = 0xB7,
    @"f64.convert_i32_u"    = 0xB8,
    @"f64.convert_i64_s"    = 0xB9,
    @"f64.convert_i64_u"    = 0xBA,
    @"f64.promote_f32"      = 0xBB,
    //
    @"i32.reinterpret_f32"  = 0xBC,
    @"i64.reinterpret_f64"  = 0xBD,
    @"f32.reinterpret_i32"  = 0xBE,
    @"f64.reinterpret_i64"  = 0xBF,
    //
    @"i32.extend8_s"        = 0xC0,
    @"i32.extend16_s"       = 0xC1,
    @"i64.extend8_s"        = 0xC2,
    @"i64.extend16_s"       = 0xC3,
    @"i64.extend32_s"       = 0xC4,
    //
    @"ref.null"             = 0xD0,
    @"ref.is_null"          = 0xD1,
    @"ref.func"             = 0xD2,
    @"ref.eq"               = 0xD3,
    @"ref.as_non_null"      = 0xD4,
    br_on_null              = 0xD5,
    br_on_non_null          = 0xD6,
    //
    @"f64.acos"             = 0xDC,
    @"f64.asin"             = 0xDD,
    @"f64.atan"             = 0xDE,
    @"f64.cos"              = 0xDF,
    @"f64.sin"              = 0xE0,
    @"f64.tan"              = 0xE1,
    @"f64.exp"              = 0xE2,
    @"f64.log"              = 0xE3,
    @"f64.atan2"            = 0xA4,
    @"f64.pow"              = 0xE5,
    @"f64.mod"              = 0xE6,
    //
    // Multi-byte opcodes
    //
    @"struct.new"           = 0xFB_00,
    @"struct.new_default"   = 0xFB_01,
    @"struct.get"           = 0xFB_02,
    @"struct.get_s"         = 0xFB_03,
    @"struct.get_u"         = 0xFB_04,
    @"struct.set"           = 0xFB_05,
    //
    @"array.new"            = 0xFB_06,
    @"array.new_default"    = 0xFB_07,
    @"array.new_fixed"      = 0xFB_08,
    @"array.new_data"       = 0xFB_09,
    @"array.new_elem"       = 0xFB_0A,
    @"array.get"            = 0xFB_0B,
    @"array.get_s"          = 0xFB_0C,
    @"array.get_u"          = 0xFB_0D,
    @"array.set"            = 0xFB_0E,
    @"array.len"            = 0xFB_0F,
    @"array.fill"           = 0xFB_10,
    @"array.copy"           = 0xFB_11,
    @"array.init_data"      = 0xFB_12,
    @"array.init_elem"      = 0xFB_13,
    //
    @"ref.test"             = 0xFB_14,
    @"ref.test_null"        = 0xFB_15,
    @"ref.cast"             = 0xFB_16,
    @"ref.cast_null"        = 0xFB_17,
    br_on_cast              = 0xFB_18,
    br_on_cast_fail         = 0xFB_19,
    @"extern.internalize"   = 0xFB_1A,
    @"extern.externalize"   = 0xFB_1B,
    @"ref.i31"              = 0xFB_1C,
    @"ref.i31_get_s"        = 0xFB_1D,
    @"ref.i31_get_u"        = 0xFB_1E,
    @"ref.cast_nop"         = 0xFB_4C,
    //
    @"string.new_utf8"                      = 0xFB_80,
    @"string.new_wtf16"                     = 0xFB_81,
    @"string.const"                         = 0xFB_82,
    @"string.measure_utf8"                  = 0xFB_83,
    @"string.measure_wtf8"                  = 0xFB_84,
    @"string.measure_wtf16"                 = 0xFB_85,
    @"string.encode_utf8"                   = 0xFB_86,
    @"string.encode_wtf16"                  = 0xFB_87,
    @"string.concat"                        = 0xFB_88,
    @"string.eq"                            = 0xFB_89,
    @"string.is_usv_sequece"                = 0xFB_8A,
    @"string.new_lossy_utf8"                = 0xFB_8B,
    @"string.new_wtf8"                      = 0xFB_8C,
    @"string.encode_lossy_utf8"             = 0xFB_8D,
    @"string.encode_wtf8"                   = 0xFB_8E,
    @"string.new_utf8_try"                  = 0xFB_8F,
    @"string.as_wtf8"                       = 0xFB_90,
    //
    @"stringview_wtf8.advance"              = 0xFB_91,
    @"stringview_wtf8.encode_utf8"          = 0xFB_92,
    @"stringview_wtf8.slice"                = 0xFB_93,
    @"stringview_wtf8.encode_lossy_utf8"    = 0xFB_94,
    @"stringview_wtf8.encode_wtf8"          = 0xFB_95,
    //
    @"string.as_wtf16"                      = 0xFB_98,
    //
    @"stringview_wtf16.length"              = 0xFB_99,
    @"stringview_wtf16.get_codeunit"        = 0xFB_9A,
    @"stringview_wtf16.encode"              = 0xFB_9B,
    @"stringview_wtf16.slice"               = 0xFB_9C,
    //
    @"string.as_iter"                       = 0xFB_A0,
    //
    @"stringview_iter.next"                 = 0xFB_A1,
    @"stringview_iter.advance"              = 0xFB_A2,
    @"stringview_iter.rewind"               = 0xFB_A3,
    @"stringview_iter.slice"                = 0xFB_A4,
    //
    @"string.compare"                       = 0xFB_A8,
    @"string.from_code_point"               = 0xFB_A9,
    @"string.hash"                          = 0xFB_AA,
    @"string.new_utf8_array"                = 0xFB_B0,
    @"string.new_wtf16_array"               = 0xFB_B1,
    @"string.encode_utf8_array"             = 0xFB_B2,
    @"string.encode_wtf16_array"            = 0xFB_B3,
    @"string.new_lossy_utf8_array"          = 0xFB_B4,
    @"string.new_wtf8_array"                = 0xFB_B5,
    @"string.encode_lossy_utf8_array"       = 0xFB_B6,
    @"string.encode_wtf8_array"             = 0xFB_B7,
    @"string.new_utf8_array_try"            = 0xFB_B8,
    //
    @"i32.trunc_sat_f32_s"  = 0xFC_00,
    @"i32.trunc_sat_f32_u"  = 0xFC_01,
    @"i32.trunc_sat_f64_s"  = 0xFC_02,
    @"i32.trunc_sat_f64_u"  = 0xFC_03,
    @"i64.trunc_sat_f32_s"  = 0xFC_04,
    @"i64.trunc_sat_f32_u"  = 0xFC_05,
    @"i64.trunc_sat_f64_s"  = 0xFC_06,
    @"i64.trunc_sat_f64_u"  = 0xFC_07,
    //
    @"memory.init"          = 0xFC_08,
    @"data.drop"            = 0xFC_09,
    @"memory.copy"          = 0xFC_0A,
    @"memory.fill"          = 0xFC_0B,
    @"table.init"           = 0xFC_0C,
    @"elem.drop"            = 0xFC_0D,
    @"table.copy"           = 0xFC_0E,
    @"table.grow"           = 0xFC_0F,
    @"table.size"           = 0xFC_10,
    @"table.fill"           = 0xFC_11,
    //
    @"v128.load"            = 0xFD_00,
    @"v128.load8x8_s"       = 0xFD_01,
    @"v128.load8x8_u"       = 0xFD_02,
    @"v128.load16x4_s"      = 0xFD_03,
    @"v128.load16x4_u"      = 0xFD_04,
    @"v128.load32x2_s"      = 0xFD_05,
    @"v128.load32x2_u"      = 0xFD_06,
    @"v128.load8_splat"     = 0xFD_07,
    @"v128.load16_splat"    = 0xFD_08,
    @"v128.load32_splat"    = 0xFD_09,
    @"v128.load64_splat"    = 0xFD_0A,
    @"v128.store"           = 0xFD_0B,
    @"v128.const"           = 0xFD_0C,
    //
    @"i8x16.shuffle"        = 0xFD_0D,
    @"i8x16.swizzle"        = 0xFD_0E,
    @"i8x16.splat"          = 0xFD_0F,
    @"i16x8.splat"          = 0xFD_10,
    @"i32x4.splat"          = 0xFD_11,
    @"i64x2.splat"          = 0xFD_12,
    @"f32x4.splat"          = 0xFD_13,
    @"f64x2.splat"          = 0xFD_14,
    //
    @"i8x16.eq"             = 0xFD_23,
    @"i8x16.ne"             = 0xFD_24,
    @"i8x16.lt_s"           = 0xFD_25,
    @"i8x16.lt_u"           = 0xFD_26,
    @"i8x16.gt_s"           = 0xFD_27,
    @"i8x16.gt_u"           = 0xFD_28,
    @"i8x16.le_s"           = 0xFD_29,
    @"i8x16.le_u"           = 0xFD_2A,
    @"i8x16.ge_s"           = 0xFD_2B,
    @"i8x16.ge_u"           = 0xFD_2C,
    //
    @"i16x8.eq"             = 0xFD_2D,
    @"i16x8.ne"             = 0xFD_2E,
    @"i16x8.lt_s"           = 0xFD_2F,
    @"i16x8.lt_u"           = 0xFD_30,
    @"i16x8.gt_s"           = 0xFD_31,
    @"i16x8.gt_u"           = 0xFD_32,
    @"i16x8.le_s"           = 0xFD_33,
    @"i16x8.le_u"           = 0xFD_34,
    @"i16x8.ge_s"           = 0xFD_35,
    @"i16x8.ge_u"           = 0xFD_36,
    //
    @"i32x4.eq"             = 0xFD_37,
    @"i32x4.ne"             = 0xFD_38,
    @"i32x4.lt_s"           = 0xFD_39,
    @"i32x4.lt_u"           = 0xFD_3A,
    @"i32x4.gt_s"           = 0xFD_3B,
    @"i32x4.gt_u"           = 0xFD_3C,
    @"i32x4.le_s"           = 0xFD_3D,
    @"i32x4.le_u"           = 0xFD_3E,
    @"i32x4.ge_s"           = 0xFD_3F,
    @"i32x4.ge_u"           = 0xFD_40,
    //
    @"f32x4.eq"             = 0xFD_41,
    @"f32x4.ne"             = 0xFD_42,
    @"f32x4.lt"             = 0xFD_43,
    @"f32x4.gt"             = 0xFD_44,
    @"f32x4.le"             = 0xFD_45,
    @"f32x4.ge"             = 0xFD_46,
    //
    @"f64x2.eq"             = 0xFD_47,
    @"f64x2.ne"             = 0xFD_48,
    @"f64x2.lt"             = 0xFD_49,
    @"f64x2.gt"             = 0xFD_4A,
    @"f64x2.le"             = 0xFD_4B,
    @"f64x2.ge"             = 0xFD_4C,
    //
    @"v128.not"             = 0xFD_4D,
    @"v128.and"             = 0xFD_4E,
    @"v128.andnot"          = 0xFD_4F,
    @"v128.or"              = 0xFD_50,
    @"v128.xor"             = 0xFD_51,
    @"v128.bitselect"       = 0xFD_52,
    @"v128.any_true"        = 0xFD_53,
    //
    @"f32x4.demote_f64x2_zero"  = 0xFD_5E,
    @"f64x2.promote_low_f32x4"  = 0xFD_5F,
    //
    @"i8x16.abs"            = 0xFD_60,
    @"i8x16.neg"            = 0xFD_61,
    @"i8x16.popcnt"         = 0xFD_62,
    @"i8x16.all_true"       = 0xFD_63,
    @"i8x16.bitmask"        = 0xFD_64,
    @"i8x16.narrow_i16x8_s" = 0xFD_65,
    @"i8x16.narrow_i16x8_u" = 0xFD_66,
    //
    @"f32x4.ceil"           = 0xFD_67,
    @"f32x4.floor"          = 0xFD_68,
    @"f32x4.trunc"          = 0xFD_69,
    @"f32x4.nearest"        = 0xFD_6A,
    //
    @"i8x16.shl"            = 0xFD_6B,
    @"i8x16.shr_s"          = 0xFD_6C,
    @"i8x16.shr_u"          = 0xFD_6D,
    @"i8x16.add"            = 0xFD_6E,
    @"i8x16.add_sat_s"      = 0xFD_6F,
    @"i8x16.add_sat_u"      = 0xFD_70,
    @"i8x16.sub"            = 0xFD_71,
    @"i8x16.sub_sat_s"      = 0xFD_72,
    @"i8x16.sub_sat_u"      = 0xFD_73,
    //
    @"f64x2.ceil"           = 0xFD_74,
    @"f64x2.floor"          = 0xFD_75,
    //
    @"i8x16.min_s"          = 0xFD_76,
    @"i8x16.min_u"          = 0xFD_77,
    @"i8x16.max_s"          = 0xFD_78,
    @"i8x16.max_u"          = 0xFD_79,
    //
    @"f64x2.trunc"          = 0xFD_7A,
    //
    @"i8x16.avgr_u"         = 0xFD_7B,
    //
    @"i16x8.extadd_pairwise_i8x16_s" = 0xFD_7C,
    @"i16x8.extadd_pairwise_i8x16_u" = 0xFD_7D,
    @"i32x4.extadd_pairwise_i16x8_s" = 0xFD_7E,
    @"i32x4.extadd_pairwise_i16x8_u" = 0xFD_7F,
    //
    @"i16x8.abs"            = 0xFD_80,
    @"i16x8.neg"            = 0xFD_81,
    //
    @"i16x8.q15mulr_sat_s"          = 0xFD_82,
    @"i16x8.all_true"               = 0xFD_83,
    @"i16x8.bitmask"                = 0xFD_84,
    @"i16x8.narrow_i32x4_s"         = 0xFD_85,
    @"i16x8.narrow_i32x4_u"         = 0xFD_86,
    @"i16x8.extend_low_i8x16_s"     = 0xFD_87,
    @"i16x8.extend_high_i8x16_s"    = 0xFD_88,
    @"i16x8.extend_low_i8x16_u"     = 0xFD_89,
    @"i16x8.extend_high_i8x16_u"    = 0xFD_8A,
    @"i16x8.shl"                    = 0xFD_8B,
    @"i16x8.shr_s"                  = 0xFD_8C,
    @"i16x8.shr_u"                  = 0xFD_8D,
    @"i16x8.add"                    = 0xFD_8E,
    @"i16x8.add_sat_s"              = 0xFD_8F,
    @"i16x8.add_sat_u"              = 0xFD_90,
    @"i16x8.sub"                    = 0xFD_91,
    @"i16x8.sub_sat_s"              = 0xFD_92,
    @"i16x8.sub_sat_u"              = 0xFD_93,
    //
    @"f64x2.nearest"                = 0xFD_94,
    //
    @"i16x8.mul"                    = 0xFD_95,
    @"i16x8.min_s"                  = 0xFD_96,
    @"i16x8.min_u"                  = 0xFD_97,
    @"i16x8.max_s"                  = 0xFD_98,
    @"i16x8.max_u"                  = 0xFD_99,
    @"i16x8.avgr_u"                 = 0xFD_9B,
    @"i16x8.extmul_low_i8x16_s"     = 0xFD_9C,
    @"i16x8.extmul_high_i8x16_s"    = 0xFD_9D,
    @"i16x8.extmul_low_i8x16_u"     = 0xFD_9E,
    @"i16x8.extmul_high_i8x16_u"    = 0xFD_9F,
    //
    @"i32x4.abs"                    = 0xFD_A0,
    @"i32x4.neg"                    = 0xFD_A1,
    @"i32x4.all_true"               = 0xFD_A3,
    @"i32x4.bitmask"                = 0xFD_A4,
    @"i32x4.extend_low_i16x8_s"     = 0xFD_A7,
    @"i32x4.extend_high_i16x8_s"    = 0xFD_A8,
    @"i32x4.extend_low_i16x8_u"     = 0xFD_A9,
    @"i32x4.extend_high_i16x8_u"    = 0xFD_AA,
    @"i32x4.shl"                    = 0xFD_AB,
    @"i32x4.shr_s"                  = 0xFD_AC,
    @"i32x4.shr_u"                  = 0xFD_AD,
    @"i32x4.add"                    = 0xFD_AE,
    @"i32x4.sub"                    = 0xFD_B1,
    @"i32x4.mul"                    = 0xFD_B5,
    @"i32x4.min_s"                  = 0xFD_B6,
    @"i32x4.min_u"                  = 0xFD_B7,
    @"i32x4.max_s"                  = 0xFD_B8,
    @"i32x4.max_u"                  = 0xFD_B9,
    @"i32x4.dot_i16x8_s"            = 0xFD_BA,
    @"i32x4.extmul_low_i16x8_s"     = 0xFD_BC,
    @"i32x4.extmul_high_i16x8_s"    = 0xFD_BD,
    @"i32x4.extmul_low_i16x8_u"     = 0xFD_BE,
    @"i32x4.extmul_high_i16x8_u"    = 0xFD_BF,
    //
    @"i64x2.abs"                    = 0xFD_C0,
    @"i64x2.neg"                    = 0xFD_C1,
    @"i64x2.all_true"               = 0xFD_C3,
    @"i64x2.bitmask"                = 0xFD_C4,
    @"i64x2.extend_low_i32x4_s"     = 0xFD_C7,
    @"i64x2.extend_high_i32x4_s"    = 0xFD_C8,
    @"i64x2.extend_low_i32x4_u"     = 0xFD_C9,
    @"i64x2.extend_high_i32x4_u"    = 0xFD_CA,
    @"i64x2.shl"                    = 0xFD_CB,
    @"i64x2.shr_s"                  = 0xFD_CC,
    @"i64x2.shr_u"                  = 0xFD_CD,
    @"i64x2.add"                    = 0xFD_CE,
    @"i64x2.sub"                    = 0xFD_D1,
    @"i64x2.mul"                    = 0xFD_D5,
    @"i64x2.eq"                     = 0xFD_D6,
    @"i64x2.ne"                     = 0xFD_D7,
    @"i64x2.lt_s"                   = 0xFD_D8,
    @"i64x2.gt_s"                   = 0xFD_D9,
    @"i64x2.le_s"                   = 0xFD_DA,
    @"i64x2.ge_s"                   = 0xFD_DB,
    @"i64x2.extmul_low_i32x4_s"     = 0xFD_DC,
    @"i64x2.extmul_high_i32x4_s"    = 0xFD_DD,
    @"i64x2.extmul_low_i32x4_u"     = 0xFD_DE,
    @"i64x2.extmul_high_i32x4_u"    = 0xFD_DF,
    //
    @"f32x4.abs"            = 0xFD_E0,
    @"f32x4.neg"            = 0xFD_E1,
    @"f32x4.sqrt"           = 0xFD_E3,
    @"f32x4.add"            = 0xFD_E4,
    @"f32x4.sub"            = 0xFD_E5,
    @"f32x4.mul"            = 0xFD_E6,
    @"f32x4.div"            = 0xFD_E7,
    @"f32x4.min"            = 0xFD_E8,
    @"f32x4.max"            = 0xFD_E9,
    @"f32x4.pmin"           = 0xFD_EA,
    @"f32x4.pmax"           = 0xFD_EB,
    //
    @"f64x2.abs"            = 0xFD_EC,
    @"f64x2.neg"            = 0xFD_ED,
    @"f64x2.sqrt"           = 0xFD_EF,
    @"f64x2.add"            = 0xFD_F0,
    @"f64x2.sub"            = 0xFD_F1,
    @"f64x2.mul"            = 0xFD_F2,
    @"f64x2.div"            = 0xFD_F3,
    @"f64x2.min"            = 0xFD_F4,
    @"f64x2.max"            = 0xFD_F5,
    @"f64x2.pmin"           = 0xFD_F6,
    @"f64x2.pmax"           = 0xFD_F7,
    //
    @"i32x4.trunc_sat_f32x4_s"      = 0xFD_F8,
    @"i32x4.trunc_sat_f32x4_u"      = 0xFD_F9,
    @"f32x4.convert_i32x4_s"        = 0xFD_FA,
    @"f32x4.convert_i32x4_u"        = 0xFD_FB,
    @"i32x4.trunc_sat_f64x2_s_zero" = 0xFD_FC,
    @"i32x4.trunc_sat_f64x2_u_zero" = 0xFD_FD,
    @"f64x2.convert_low_i32x4_s"    = 0xFD_FE,
    @"f64x2.convert_low_i32x4_u"    = 0xFD_FF,
    //




    // zig fmt: on
};
