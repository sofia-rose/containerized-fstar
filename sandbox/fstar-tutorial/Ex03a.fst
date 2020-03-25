module Ex03a

open FStar.Mul

val factorial : nat -> Tot nat
let rec factorial n =
  if n = 0 then 1 else n * (factorial (n -1))

val factorial_is_positive: x:nat -> Lemma (factorial x > 0)
let rec factorial_is_positive x =
  match x with
  | 0 -> ()
  | _ -> factorial_is_positive (x - 1)

val factorial_is_greater_than_arg: x:nat{x > 2} -> Lemma (factorial x > x)
let rec factorial_is_greater_than_arg x =
  match x with
  | 3 -> ()
  | _ -> factorial_is_greater_than_arg (x -1)
