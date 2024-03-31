(module
  (type (;0;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;1;) (func (param i32)))
  (type (;2;) (func))
  (import "wasi_snapshot_preview1" "fd_write" (func $fd_write|wasi_snapshot_preview1 (type 0)))
  (import "wasi_snapshot_preview1" "proc_exit" (func $proc_exit|wasi_snapshot_preview1 (type 1)))
  (func $wasi-hello-world.main (type 2)
    (local i32 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    i32.const 0
    local.set 1
    block  ;; label = @1
      i32.const 0
      i32.load8_u offset=16777230
      br_if 0 (;@1;)
      i32.const 0
      i32.const 1
      i32.store8 offset=16777230
    end
    block  ;; label = @1
      loop  ;; label = @2
        local.get 0
        i32.const 13
        local.get 1
        i32.sub
        i32.store offset=8
        local.get 0
        local.get 1
        i32.const 16777216
        i32.add
        i32.store offset=4
        i32.const 2
        local.get 0
        i32.const 4
        i32.add
        i32.const 1
        local.get 0
        i32.const 12
        i32.add
        call $fd_write|wasi_snapshot_preview1
        i32.const 65535
        i32.and
        br_if 1 (;@1;)
        local.get 0
        i32.load offset=12
        local.get 1
        i32.add
        local.tee 1
        i32.const 13
        i32.ne
        br_if 0 (;@2;)
      end
    end
    i32.const 0
    i32.const 0
    i32.store8 offset=16777230
    local.get 0
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $_start (type 2)
    call $wasi-hello-world.main
    i32.const 0
    call $proc_exit|wasi_snapshot_preview1
    unreachable)
  (memory (;0;) 257)
  (global $__stack_pointer (mut i32) (i32.const 16777216))
  (export "memory" (memory 0))
  (export "_start" (func $_start))
  (data $.data (i32.const 16777216) "Hello, world!\00"))
