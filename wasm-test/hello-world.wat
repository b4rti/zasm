(module
  (type (;0;) (func (param i32)))
  (type (;1;) (func))
  (import "env" "print" (func $print (type 0)))
  (func $helloWorld (type 1)
    i32.const 1048576
    call $print)
  (memory (;0;) 17)
  (global $__stack_pointer (mut i32) (i32.const 1048576))
  (export "memory" (memory 0))
  (export "helloWorld" (func $helloWorld))
  (data $.data (i32.const 1048576) "Hello, world!\00"))
