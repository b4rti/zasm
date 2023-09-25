(module
  (type (;0;) (func (param i32)))
  (type (;1;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;2;) (func))
  (type (;3;) (func (param i32 i32 i32 i32)))
  (type (;4;) (func (param i32 i32)))
  (import "wasi_snapshot_preview1" "proc_exit" (func $proc_exit|wasi_snapshot_preview1 (type 0)))
  (import "wasi_snapshot_preview1" "fd_write" (func $fd_write|wasi_snapshot_preview1 (type 1)))
  (func $wasi-hello-world.main (type 2)
    (local i32 i32 i64 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 0
    global.set $__stack_pointer
    i32.const 0
    local.set 1
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            i32.const 0
            i32.load8_u offset=1048669
            br_if 0 (;@4;)
            i32.const 0
            i32.const 1
            i32.store8 offset=1048669
            block  ;; label = @5
              block  ;; label = @6
                loop  ;; label = @7
                  local.get 1
                  i32.const 13
                  i32.gt_u
                  br_if 4 (;@3;)
                  local.get 0
                  i32.const 8
                  i32.add
                  i32.const 2
                  local.get 1
                  i32.const 1048655
                  i32.add
                  i32.const 13
                  local.get 1
                  i32.sub
                  call $os.write
                  local.get 0
                  i64.load offset=8
                  local.tee 2
                  i64.const 281470681743360
                  i64.and
                  i64.eqz
                  i32.eqz
                  br_if 1 (;@6;)
                  local.get 1
                  local.get 2
                  i32.wrap_i64
                  i32.add
                  local.tee 3
                  local.get 1
                  i32.lt_u
                  br_if 5 (;@2;)
                  local.get 3
                  local.set 1
                  local.get 3
                  i32.const 13
                  i32.ne
                  br_if 0 (;@7;)
                end
                i32.const 0
                i32.load8_u offset=1048669
                br_if 1 (;@5;)
                i32.const 1048630
                i32.const 24
                call $builtin.default_panic
                unreachable
              end
              i32.const 0
              i32.load8_u offset=1048669
              i32.eqz
              br_if 4 (;@1;)
            end
            i32.const 0
            i32.const 0
            i32.store8 offset=1048669
            local.get 0
            i32.const 16
            i32.add
            global.set $__stack_pointer
            return
          end
          i32.const 1048630
          i32.const 24
          call $builtin.default_panic
          unreachable
        end
        i32.const 1048576
        i32.const 36
        call $builtin.default_panic
        unreachable
      end
      i32.const 1048613
      i32.const 16
      call $builtin.default_panic
      unreachable
    end
    i32.const 1048630
    i32.const 24
    call $builtin.default_panic
    unreachable)
  (func $os.write (type 3) (param i32 i32 i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 4
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        local.get 3
        br_if 0 (;@2;)
        local.get 0
        i64.const 0
        i64.store align=4
        br 1 (;@1;)
      end
      local.get 4
      local.get 3
      i32.store offset=8
      local.get 4
      local.get 2
      i32.store offset=4
      local.get 4
      i32.const -1431655766
      i32.store offset=12
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    local.get 1
                                    local.get 4
                                    i32.const 4
                                    i32.add
                                    i32.const 1
                                    local.get 4
                                    i32.const 12
                                    i32.add
                                    call $fd_write|wasi_snapshot_preview1
                                    i32.const 65535
                                    i32.and
                                    br_table 1 (;@15;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 5 (;@11;) 0 (;@16;) 6 (;@10;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 7 (;@9;) 0 (;@16;) 8 (;@8;) 0 (;@16;) 4 (;@12;) 9 (;@7;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 2 (;@14;) 3 (;@13;) 10 (;@6;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 11 (;@5;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 12 (;@4;) 13 (;@3;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 0 (;@16;) 14 (;@2;) 0 (;@16;)
                                  end
                                  local.get 0
                                  i32.const 15
                                  i32.store16 offset=4
                                  br 14 (;@1;)
                                end
                                local.get 0
                                i32.const 0
                                i32.store16 offset=4
                                local.get 0
                                local.get 4
                                i32.load offset=12
                                i32.store
                                br 13 (;@1;)
                              end
                              i32.const 1048630
                              i32.const 24
                              call $builtin.default_panic
                              unreachable
                            end
                            i32.const 1048630
                            i32.const 24
                            call $builtin.default_panic
                            unreachable
                          end
                          i32.const 1048630
                          i32.const 24
                          call $builtin.default_panic
                          unreachable
                        end
                        i32.const 1048630
                        i32.const 24
                        call $builtin.default_panic
                        unreachable
                      end
                      local.get 0
                      i64.const 47244640256
                      i64.store align=4
                      br 8 (;@1;)
                    end
                    i32.const 1048630
                    i32.const 24
                    call $builtin.default_panic
                    unreachable
                  end
                  local.get 0
                  i64.const 4294967296
                  i64.store align=4
                  br 6 (;@1;)
                end
                local.get 0
                i64.const 8589934592
                i64.store align=4
                br 5 (;@1;)
              end
              local.get 0
              i64.const 12884901888
              i64.store align=4
              br 4 (;@1;)
            end
            local.get 0
            i64.const 17179869184
            i64.store align=4
            br 3 (;@1;)
          end
          local.get 0
          i64.const 30064771072
          i64.store align=4
          br 2 (;@1;)
        end
        local.get 0
        i64.const 34359738368
        i64.store align=4
        br 1 (;@1;)
      end
      local.get 0
      i64.const 30064771072
      i64.store align=4
    end
    local.get 4
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (func $builtin.default_panic (type 4) (param i32 i32)
    (local i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 2
    global.set $__stack_pointer
    local.get 2
    local.get 1
    i32.store offset=12
    local.get 2
    local.get 0
    i32.store offset=8
    local.get 2
    i32.const 8
    i32.add
    call $debug.print__anon_1954
    unreachable
    unreachable)
  (func $_start (type 2)
    call $wasi-hello-world.main
    i32.const 0
    call $proc_exit|wasi_snapshot_preview1
    unreachable)
  (func $debug.print__anon_1954 (type 0) (param i32)
    (local i32 i32 i32 i64 i32)
    global.get $__stack_pointer
    i32.const 16
    i32.sub
    local.tee 1
    global.set $__stack_pointer
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            i32.const 0
            i32.load8_u offset=1048669
            br_if 0 (;@4;)
            i32.const 0
            i32.const 1
            i32.store8 offset=1048669
            local.get 0
            i32.load offset=4
            local.tee 2
            i32.eqz
            br_if 3 (;@1;)
            local.get 0
            i32.load
            local.set 3
            i32.const 0
            local.set 0
            block  ;; label = @5
              loop  ;; label = @6
                local.get 2
                local.get 0
                i32.lt_u
                br_if 3 (;@3;)
                local.get 1
                i32.const 8
                i32.add
                i32.const 2
                local.get 3
                local.get 0
                i32.add
                local.get 2
                local.get 0
                i32.sub
                call $os.write
                local.get 1
                i64.load offset=8
                local.tee 4
                i64.const 281470681743360
                i64.and
                i64.eqz
                i32.eqz
                br_if 1 (;@5;)
                local.get 0
                local.get 4
                i32.wrap_i64
                i32.add
                local.tee 5
                local.get 0
                i32.lt_u
                br_if 4 (;@2;)
                local.get 5
                local.set 0
                local.get 5
                local.get 2
                i32.ne
                br_if 0 (;@6;)
              end
              i32.const 0
              i32.load8_u offset=1048669
              br_if 4 (;@1;)
              i32.const 1048630
              i32.const 24
              call $builtin.default_panic
              unreachable
            end
            i32.const 0
            i32.load8_u offset=1048669
            br_if 3 (;@1;)
            i32.const 1048630
            i32.const 24
            call $builtin.default_panic
            unreachable
          end
          i32.const 1048630
          i32.const 24
          call $builtin.default_panic
          unreachable
        end
        i32.const 1048576
        i32.const 36
        call $builtin.default_panic
        unreachable
      end
      i32.const 1048613
      i32.const 16
      call $builtin.default_panic
      unreachable
    end
    i32.const 0
    i32.const 0
    i32.store8 offset=1048669
    local.get 1
    i32.const 16
    i32.add
    global.set $__stack_pointer)
  (memory (;0;) 17)
  (global $__stack_pointer (mut i32) (i32.const 1048576))
  (export "memory" (memory 0))
  (export "_start" (func $_start))
  (data $.rodata (i32.const 1048576) "start index is larger than end index\00integer overflow\00reached unreachable code\00Hello, world!\00"))
