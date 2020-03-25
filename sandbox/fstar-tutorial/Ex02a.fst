module Ex02a

type filename = string

val canWrite : filename -> Tot bool
let canWrite (f:filename) =
  match f with
    | "demo/tempfile" -> true
    | _ -> false

val canRead : filename -> Tot bool
let canRead (f:filename) =
  canWrite f || f = "demo/README"
