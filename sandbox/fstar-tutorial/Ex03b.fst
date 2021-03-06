module Ex03b

open FStar.Mul

val fibonacci : nat -> Tot (x:nat{x>0})
let rec fibonacci n =
  if n <= 1 then 1 else fibonacci (n - 1) + fibonacci (n - 2)
