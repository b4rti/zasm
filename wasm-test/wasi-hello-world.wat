(module
  (type (;0;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;1;) (func (param i32)))
  (type (;2;) (func))
  (import "wasi_snapshot_preview1" "fd_write" (func (;0;) (type 0)))
  (import "wasi_snapshot_preview1" "proc_exit" (func (;1;) (type 1)))
  (func (;2;) (type 2)
    (local i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 0
    global.set 0
    i32.const 0
    local.set 1
    block  ;; label = @1
      i32.const 0
      i32.load8_u offset=1048590
      br_if 0 (;@1;)
      i32.const 0
      i32.const 1
      i32.store8 offset=1048590
    end
    block  ;; label = @1
      loop  ;; label = @2
        local.get 1
        i32.const 13
        i32.eq
        br_if 1 (;@1;)
        local.get 0
        i32.const 13
        local.get 1
        i32.sub
        i32.store offset=8
        local.get 0
        local.get 1
        i32.const 1048576
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
        call 0
        i32.const 65535
        i32.and
        br_if 1 (;@1;)
        local.get 0
        i32.load offset=12
        local.get 1
        i32.add
        local.set 1
        br 0 (;@2;)
      end
    end
    i32.const 0
    i32.const 0
    i32.store8 offset=1048590
    local.get 0
    i32.const 16
    i32.add
    global.set 0)
  (func (;3;) (type 2)
    call 2
    i32.const 0
    call 1
    unreachable)
  (memory (;0;) 17)
  (global (;0;) (mut i32) (i32.const 1048576))
  (export "memory" (memory 0))
  (export "_start" (func 3))
  (data (;0;) (i32.const 1048576) "Hello, world!\00"))
