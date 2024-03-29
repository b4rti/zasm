;; Test throw_ref instruction.

(module
  (tag $e0)
  (tag $e1)

  (func (export "catch-throw_ref-0")
    (block $h (result exnref)
      (try_table (catch_ref $e0 $h) (throw $e0))
      (unreachable)
    )
    (throw_ref)
  )

  (func (export "catch-throw_ref-1") (param i32) (result i32)
    (block $h (result exnref)
      (try_table (result i32) (catch_ref $e0 $h) (throw $e0))
      (return)
    )
    (if (param exnref) (i32.eqz (local.get 0))
      (then (throw_ref))
      (else (drop))
    )
    (i32.const 23)
  )

  (func (export "catchall-throw_ref-0")
    (block $h (result exnref)
      (try_table (result exnref) (catch_all_ref $h) (throw $e0))
    )
    (throw_ref)
  )

  (func (export "catchall-throw_ref-1") (param i32) (result i32)
    (block $h (result exnref)
      (try_table (result i32) (catch_all_ref $h) (throw $e0))
      (return)
    )
    (if (param exnref) (i32.eqz (local.get 0))
      (then (throw_ref))
      (else (drop))
    )
    (i32.const 23)
  )

  (func (export "throw_ref-nested") (param i32) (result i32)
    (local $exn1 exnref)
    (local $exn2 exnref)
    (block $h1 (result exnref)
      (try_table (result i32) (catch_ref $e1 $h1) (throw $e1))
      (return)
    )
    (local.set $exn1)
    (block $h2 (result exnref)
      (try_table (result i32) (catch_ref $e0 $h2) (throw $e0))
      (return)
    )
    (local.set $exn2)
    (if (i32.eq (local.get 0) (i32.const 0))
      (then (throw_ref (local.get $exn1)))
    )
    (if (i32.eq (local.get 0) (i32.const 1))
      (then (throw_ref (local.get $exn2)))
    )
    (i32.const 23)
  )

  (func (export "throw_ref-recatch") (param i32) (result i32)
    (local $e exnref)
    (block $h1 (result exnref)
      (try_table (result i32) (catch_ref $e0 $h1) (throw $e0))
      (return)
    )
    (local.set $e)
    (block $h2 (result exnref)
      (try_table (result i32) (catch_ref $e0 $h2)
        (if (i32.eqz (local.get 0))
          (then (throw_ref (local.get $e)))
        )
        (i32.const 42)
      )
      (return)
    )
    (drop) (i32.const 23)
  )

  (func (export "throw_ref-stack-polymorphism")
    (local $e exnref)
    (block $h (result exnref)
      (try_table (result f64) (catch_ref $e0 $h) (throw $e0))
      (unreachable)
    )
    (local.set $e)
    (i32.const 1)
    (throw_ref (local.get $e))
  )
)

(assert_exception (invoke "catch-throw_ref-0"))

(assert_exception (invoke "catch-throw_ref-1" (i32.const 0)))
(assert_return (invoke "catch-throw_ref-1" (i32.const 1)) (i32.const 23))

(assert_exception (invoke "catchall-throw_ref-0"))

(assert_exception (invoke "catchall-throw_ref-1" (i32.const 0)))
(assert_return (invoke "catchall-throw_ref-1" (i32.const 1)) (i32.const 23))
(assert_exception (invoke "throw_ref-nested" (i32.const 0)))
(assert_exception (invoke "throw_ref-nested" (i32.const 1)))
(assert_return (invoke "throw_ref-nested" (i32.const 2)) (i32.const 23))

(assert_return (invoke "throw_ref-recatch" (i32.const 0)) (i32.const 23))
(assert_return (invoke "throw_ref-recatch" (i32.const 1)) (i32.const 42))

(assert_exception (invoke "throw_ref-stack-polymorphism"))

(assert_invalid (module (func (throw_ref))) "type mismatch")
(assert_invalid (module (func (block (throw_ref)))) "type mismatch")
