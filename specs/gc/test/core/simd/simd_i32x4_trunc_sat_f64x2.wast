;; Tests for i32x4 trunc sat conversions from float.

(module
  (func (export "i32x4.trunc_sat_f64x2_s_zero") (param v128) (result v128) (i32x4.trunc_sat_f64x2_s_zero (local.get 0)))
  (func (export "i32x4.trunc_sat_f64x2_u_zero") (param v128) (result v128) (i32x4.trunc_sat_f64x2_u_zero (local.get 0)))
)


;; i32x4.trunc_sat_f64x2_s_zero
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 0.0 0.0))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -0.0 -0.0))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 1.5 1.5))
                                                      (v128.const i32x4 1 1 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -1.5 -1.5))
                                                      (v128.const i32x4 -1 -1 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 1.9 1.9))
                                                      (v128.const i32x4 1 1 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 2.0 2.0))
                                                      (v128.const i32x4 2 2 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -1.9 -1.9))
                                                      (v128.const i32x4 -1 -1 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -2.0 -2.0))
                                                      (v128.const i32x4 -2 -2 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 2147483520.0 2147483520.0))
                                                      (v128.const i32x4 2147483520 2147483520 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -2147483520.0 -2147483520.0))
                                                      (v128.const i32x4 -2147483520 -2147483520 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 2147483648.0 2147483648.0))
                                                      (v128.const i32x4 2147483647 2147483647 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -2147483648.0 -2147483648.0))
                                                      (v128.const i32x4 -2147483648 -2147483648 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 4294967294.0 4294967294.0))
                                                      (v128.const i32x4 2147483647 2147483647 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -4294967294.0 -4294967294.0))
                                                      (v128.const i32x4 -2147483648 -2147483648 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 2147483647.0 2147483647.0))
                                                      (v128.const i32x4 2147483647 2147483647 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -2147483647.0 -2147483647.0))
                                                      (v128.const i32x4 -2147483647 -2147483647 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 4294967294.0 4294967294.0))
                                                      (v128.const i32x4 2147483647 2147483647 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 4294967295.0 4294967295.0))
                                                      (v128.const i32x4 2147483647 2147483647 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 4294967296.0 4294967296.0))
                                                      (v128.const i32x4 2147483647 2147483647 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 0x1p-149 0x1p-149))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -0x1p-149 -0x1p-149))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 0x1p-126 0x1p-126))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -0x1p-126 -0x1p-126))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 0x1p-1 0x1p-1))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -0x1p-1 -0x1p-1))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 0x1p+0 0x1p+0))
                                                      (v128.const i32x4 1 1 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -0x1p+0 -0x1p+0))
                                                      (v128.const i32x4 -1 -1 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 0x1.19999ap+0 0x1.19999ap+0))
                                                      (v128.const i32x4 1 1 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -0x1.19999ap+0 -0x1.19999ap+0))
                                                      (v128.const i32x4 -1 -1 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 0x1.921fb6p+2 0x1.921fb6p+2))
                                                      (v128.const i32x4 6 6 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -0x1.921fb6p+2 -0x1.921fb6p+2))
                                                      (v128.const i32x4 -6 -6 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 0x1.fffffep+127 0x1.fffffep+127))
                                                      (v128.const i32x4 2147483647 2147483647 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -0x1.fffffep+127 -0x1.fffffep+127))
                                                      (v128.const i32x4 -2147483648 -2147483648 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 0x1.ccccccp-1 0x1.ccccccp-1))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -0x1.ccccccp-1 -0x1.ccccccp-1))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 0x1.fffffep-1 0x1.fffffep-1))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -0x1.fffffep-1 -0x1.fffffep-1))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 0x1.921fb6p+2 0x1.921fb6p+2))
                                                      (v128.const i32x4 6 6 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -0x1.921fb6p+2 -0x1.921fb6p+2))
                                                      (v128.const i32x4 -6 -6 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 0x1.fffffep+127 0x1.fffffep+127))
                                                      (v128.const i32x4 2147483647 2147483647 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -0x1.fffffep+127 -0x1.fffffep+127))
                                                      (v128.const i32x4 -2147483648 -2147483648 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 +inf +inf))
                                                      (v128.const i32x4 2147483647 2147483647 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -inf -inf))
                                                      (v128.const i32x4 -2147483648 -2147483648 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 +nan +nan))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -nan -nan))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 nan:0x444444 nan:0x444444))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -nan:0x444444 -nan:0x444444))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 42 42))
                                                      (v128.const i32x4 42 42 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 -42 -42))
                                                      (v128.const i32x4 -42 -42 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 0123456792.0 0123456792.0))
                                                      (v128.const i32x4 123456792 123456792 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_s_zero" (v128.const f64x2 01234567890.0 01234567890.0))
                                                      (v128.const i32x4 1234567890 1234567890 0 0))

;; i32x4.trunc_sat_f64x2_u_zero
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 0.0 0.0))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -0.0 -0.0))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 1.5 1.5))
                                                      (v128.const i32x4 1 1 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -1.5 -1.5))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 1.9 1.9))
                                                      (v128.const i32x4 1 1 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 2.0 2.0))
                                                      (v128.const i32x4 2 2 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -1.9 -1.9))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -2.0 -2.0))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 2147483520.0 2147483520.0))
                                                      (v128.const i32x4 2147483520 2147483520 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -2147483520.0 -2147483520.0))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 2147483648.0 2147483648.0))
                                                      (v128.const i32x4 2147483648 2147483648 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -2147483648.0 -2147483648.0))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 4294967294.0 4294967294.0))
                                                      (v128.const i32x4 4294967294 4294967294 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -4294967294.0 -4294967294.0))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 2147483647.0 2147483647.0))
                                                      (v128.const i32x4 2147483647 2147483647 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -2147483647.0 -2147483647.0))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 4294967294.0 4294967294.0))
                                                      (v128.const i32x4 4294967294 4294967294 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 4294967295.0 4294967295.0))
                                                      (v128.const i32x4 4294967295 4294967295 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 4294967296.0 4294967296.0))
                                                      (v128.const i32x4 4294967295 4294967295 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 0x1p-149 0x1p-149))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -0x1p-149 -0x1p-149))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 0x1p-126 0x1p-126))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -0x1p-126 -0x1p-126))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 0x1p-1 0x1p-1))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -0x1p-1 -0x1p-1))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 0x1p+0 0x1p+0))
                                                      (v128.const i32x4 1 1 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -0x1p+0 -0x1p+0))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 0x1.19999ap+0 0x1.19999ap+0))
                                                      (v128.const i32x4 1 1 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -0x1.19999ap+0 -0x1.19999ap+0))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 0x1.921fb6p+2 0x1.921fb6p+2))
                                                      (v128.const i32x4 6 6 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -0x1.921fb6p+2 -0x1.921fb6p+2))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 0x1.fffffep+127 0x1.fffffep+127))
                                                      (v128.const i32x4 4294967295 4294967295 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -0x1.fffffep+127 -0x1.fffffep+127))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 0x1.ccccccp-1 0x1.ccccccp-1))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -0x1.ccccccp-1 -0x1.ccccccp-1))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 0x1.fffffep-1 0x1.fffffep-1))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -0x1.fffffep-1 -0x1.fffffep-1))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 0x1.921fb6p+2 0x1.921fb6p+2))
                                                      (v128.const i32x4 6 6 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -0x1.921fb6p+2 -0x1.921fb6p+2))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 0x1.fffffep+127 0x1.fffffep+127))
                                                      (v128.const i32x4 4294967295 4294967295 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -0x1.fffffep+127 -0x1.fffffep+127))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 +inf +inf))
                                                      (v128.const i32x4 4294967295 4294967295 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -inf -inf))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 +nan +nan))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -nan -nan))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 nan:0x444444 nan:0x444444))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -nan:0x444444 -nan:0x444444))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 42 42))
                                                      (v128.const i32x4 42 42 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 -42 -42))
                                                      (v128.const i32x4 0 0 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 0123456792.0 0123456792.0))
                                                      (v128.const i32x4 123456792 123456792 0 0))
(assert_return (invoke "i32x4.trunc_sat_f64x2_u_zero" (v128.const f64x2 01234567890.0 01234567890.0))
                                                      (v128.const i32x4 1234567890 1234567890 0 0))

;; type check
(assert_invalid (module (func (result v128) (i32x4.trunc_sat_f64x2_s_zero (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (result v128) (i32x4.trunc_sat_f64x2_u_zero (i32.const 0)))) "type mismatch")

;; Test operation with empty argument

(assert_invalid
  (module
    (func $i32x4.trunc_sat_f64x2_s_zero-arg-empty (result v128)
      (i32x4.trunc_sat_f64x2_s_zero)
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (func $i32x4.trunc_sat_f64x2_u_zero-arg-empty (result v128)
      (i32x4.trunc_sat_f64x2_u_zero)
    )
  )
  "type mismatch"
)

