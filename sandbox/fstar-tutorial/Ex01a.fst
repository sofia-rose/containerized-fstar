module Ex01a

open FStar.Exn
open FStar.All

type filename = string

let canWrite (f:filename) =
  match f with
    | "demo/tempfile" -> true
    | _ -> false

let canRead (f:filename) =
  canWrite f || f = "demo/README"

val read : f:filename{canRead f} -> ML string
let read f = FStar.IO.print_string ("Dummy read of file " ^ f ^ "\n"); f

val write : f:filename{canWrite f } -> string -> ML unit
let write f s = FStar.IO.print_string ("Dummy write of string " ^ s ^ " to file " ^ f ^ "\n")
