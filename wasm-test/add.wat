(module
  (type (;0;) (func (param i32 i32) (result i32)))
  (func (;0;) (type 0) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    i32.add
    i32.const 72
    i32.add)
  (memory (;0;) 17)
  (global (;0;) (mut i32) (i32.const 1048576))
  (global (;1;) i32 (i32.const 1048576))
  (global (;2;) i32 (i32.const 1048580))
  (export "memory" (memory 0))
  (export "add" (func 0))
  (export "nice" (global 1))
  (export "blaze_it" (global 2))
  (data (;0;) (i32.const 1048576) "E\00\00\00")
  (data (;1;) (i32.const 1048580) "\08\00\10\00420\00"))
