type var = string Source.phrase

type Value.ref_ += ExternRef of int32
type num = Value.num Source.phrase
type ref_ = Value.ref_ Source.phrase
type literal = Value.t Source.phrase

type definition = definition' Source.phrase
and definition' =
  | Textual of Ast.module_
  | Encoded of string * string
  | Quoted of string * string

type action = action' Source.phrase
and action' =
  | Invoke of var option * Ast.name * literal list
  | Get of var option * Ast.name

type nanop = nanop' Source.phrase
and nanop' = (Lib.void, Lib.void, nan, nan) Value.op
and nan = CanonicalNan | ArithmeticNan

type num_pat =
  | NumPat of num
  | NanPat of nanop

type vec_pat =
  | VecPat of (V128.shape * num_pat list) Value.vecop

type ref_pat =
  | RefPat of ref_
  | RefTypePat of Types.heap_type
  | NullPat

type result = result' Source.phrase
and result' =
  | NumResult of num_pat
  | VecResult of vec_pat
  | RefResult of ref_pat

type assertion = assertion' Source.phrase
and assertion' =
  | AssertMalformed of definition * string
  | AssertInvalid of definition * string
  | AssertUnlinkable of definition * string
  | AssertUninstantiable of definition * string
  | AssertReturn of action * result list
  | AssertTrap of action * string
  | AssertExhaustion of action * string

type command = command' Source.phrase
and command' =
  | Module of var option * definition
  | Register of Ast.name * var option
  | Action of action
  | Assertion of assertion
  | Meta of meta

and meta = meta' Source.phrase
and meta' =
  | Input of var option * string
  | Output of var option * string option
  | Script of var option * script

and script = command list


let () =
  let type_of_ref' = !Value.type_of_ref' in
  Value.type_of_ref' := function
    | ExternRef _ -> Types.ExternHT
    | r -> type_of_ref' r

let () =
  let string_of_ref' = !Value.string_of_ref' in
  Value.string_of_ref' := function
    | ExternRef n -> "ref " ^ Int32.to_string n
    | r -> string_of_ref' r

let () =
  let eq_ref' = !Value.eq_ref' in
  Value.eq_ref' := fun r1 r2 ->
    match r1, r2 with
    | ExternRef n1, ExternRef n2 -> n1 = n2
    | _, _ -> eq_ref' r1 r2
