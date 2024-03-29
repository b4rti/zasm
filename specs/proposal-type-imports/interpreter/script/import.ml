open Source
open Ast
open Types

module Unknown = Error.Make ()
exception Unknown = Unknown.Error  (* indicates unknown import name *)

module Registry = Map.Make(struct type t = Ast.name let compare = compare end)
let registry = ref Registry.empty

let register name lookup = registry := Registry.add name lookup !registry

let lookup (ImportType (et, module_name, item_name)) at : Instance.extern =
  try Registry.find module_name !registry item_name et with Not_found ->
    Unknown.error at
      ("unknown import \"" ^ string_of_name module_name ^
        "\".\"" ^ string_of_name item_name ^ "\"")

let link m =
  let ModuleType (_, its, _) = Types.sem_module_type (module_type_of m) in
  List.map2 lookup its (List.map Source.at m.it.imports)
