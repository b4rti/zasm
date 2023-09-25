(module
  (type (;0;) (func (param i32)))
  (type (;1;) (func))
  (import "env" "print" (func (;0;) (type 0)))
  (func (;1;) (type 1)
    global.get 1
    i32.const 1048576
    i32.add
    call 0)
  (memory (;0;) 17)
  (global (;0;) (mut i32) (i32.const 1048576))
  (global (;1;) i32 (i32.const 0))
  (export "memory" (memory 0))
  (export "helloWorld" (func 1))
  (data (;0;) (i32.const 1048576) "Hello, world!\00"))
