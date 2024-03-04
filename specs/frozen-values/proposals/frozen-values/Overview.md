# Frozen-value Proposal

## Summary

This proposal allows to build immutable values of a recursive type.


## Motivation

### Building recursive values

Let's say you have a recursive type `$t`, currently you can build a value of type `$t` like this:

```wat
(module
  (rec
    (type $t (struct (field $f (mut (ref null $t))))))

  (func $loop (result (ref $t))
    (local $l (ref $t))
    (local.set $l (struct.new $t (ref.null $t)))
    (struct.set $t $f (local.get $l) (local.get $l))
    (local.get $l)
  )
)
```

### Building immutable recursive values ?

Now, let us define a type `$t'` which is the same as `$t` but with an immutable field `$f`:

```wat
(module
  (rec
    (type $t  (struct (field $f (mut (ref null $t))))))

  (rec
    (type $t' (struct (field $f      (ref      $t')))))

  (func $loop (result (ref $t)) ... )
)
```

Currently, there's no way to build a value of type `$t'`.

### Globals

Similarly, a global needs to be nullable in some cases:

```wat
(module
  (rec (type $t (freeze $t) (struct (field $f (ref $t))))))
  (global $g (mut (ref null $t)) (ref.null $t))

  (func $f (result (ref $t))
    (ref.as_non_null (global.get $g))
  )
  (func $loop (result (ref $t)) ...)

  (func $st
    (global.set $g (call $loop))
    (drop (call $f))
  )

  (start $st))
```

### The point ?

The same as immutable values in general:
- cleaner API / preserve code invariants ;
- avoid read barriers ;
- being more explicit about the use.

Could also avoid null checks and allow creating immutable arrays.

### Who might be interested ?

It would be useful in the two existing OCaml compiler [Wasocaml](https://github.com/OCamlPro/wasocaml) and [wasm_of_ocaml](https://github.com/ocaml-wasm/wasm_of_ocaml). [Hoot](https://gitlab.com/spritely/guile-hoot/) would be happy to experiment with the proposal.

## Overview

### Freezing

Our proposal allows to build immutable recursive values in the following way:

```wat
(module
  (rec
    (type $t         freezable  (struct (field $f (mut (ref null $t))))))

  (rec
    (type $t_freeze (freeze $t) (struct (field $f      (ref      $t_freeze)))))

  (func $loop_tmp (result (ref $t)) ... )

  (func $loop (result (ref $t_freeze))
    (ref.freeze $t_freeze $t (call $loop_tmp))
  )
)
```

### The idea

The *freezability* check can be similar to the sub-typing rules:
  - there should be the same (or less ?) fields ;
  - can remove `mut` annotations ;
  - can remove `null` annotations ;
  - fields should be (frozen versions of) subtypes (maybe also upcasts ?).

After the freeze, the freezable values should not be accessed:
  - dynamic checks on freezable types accesses ;
  - the freeze operation is expected to walk the value and flip a *frozen* bit ;
  - trap if fields are still null at freeze time.
  
Heuristic: unfrozen values are seldom accessed, frozen ones can be accessed a lot

Freezing is not 'fixed number of hardware instruction', but the combined time of building then freezing is kind of an amortized version of it.


### Phases

In order to be able to freeze global we introduce phases:

```wat
(module
  (global $g (mut (ref null $t)) freezable (ref.null $t))
  (global $g_frozen (ref $t) (freeze $g) (phase 1))

  (func $f (phase 1) (result (ref $t))
    (global.get $g_frozen)
  )
  (func $loop (phase 0) (result (ref $t)) ...)

  (func $st_0 (phase 0) (global.set $g (call $loop)))
  (func $st_1 (phase 1) (drop (call $f)))
  (start $st_0 (phase 0))
  (start $st_1 (phase 1))
)
```

The idea:

- invariant: cannot call a function of phase $n$ before the end of the start of phase $n-1$ ;
- a function can only refer to values of phase less or equal than its own phase (ref and calls) ;
- each phase can have one start ;
- starts are run in phase order ;
- global are frozen at the end of the previous phase ;
-  failure to freeze is a panic ;
- accessing an unfrozen global from a previous phase is a panic ;
- cannot export freezable global.

Also:

- if multiple start functions seems distasteful, we could have a `call_and_freeze` instruction moving to the next phase ;
- default phase is 0 ;
- global freeze can change the type of its contents ;
- encoding: not really thought, could be compact.

## Links

- [design issue](https://github.com/WebAssembly/design/issues/1493)
- [CG notes 2023-12-05](https://github.com/WebAssembly/meetings/blob/main/main/2023/CG-12-05.md#frozen-proposal)
