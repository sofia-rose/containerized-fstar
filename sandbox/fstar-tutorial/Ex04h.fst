module Ex04h

val length : list 'a -> Tot nat
let rec length l = match l with
  | [] -> 0
  | _ :: tl -> 1 + length tl

val nth: l:list 'a -> n:nat{n < length l} -> Tot 'a
let rec nth l n = match (n, l) with
  | (0, x :: _) -> x
  | (i, _ :: xs) -> nth xs (i-1)
