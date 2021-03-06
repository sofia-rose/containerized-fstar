module Ex05b

val fibonacci : nat -> Tot nat
let rec fibonacci n =
  if n <= 1 then 1 else fibonacci (n - 1) + fibonacci (n - 2)

val fib : nat -> nat -> n:nat -> Tot nat (decreases n)
let rec fib a b n =
  match n with
  | 0 -> a
  | _ -> fib b (a+b) (n-1)

val fib_is_ok_aux :
     (n : nat)
  -> (k : nat)
  -> Lemma (fib (fibonacci k) (fibonacci (k + 1)) n == fibonacci (k + n))
let rec fib_is_ok_aux n k =
  if n = 0 then () else fib_is_ok_aux (n - 1) (k + 1)

val fib_is_ok : n:nat -> Lemma (ensures fib 1 1 n = fibonacci n)
let fib_is_ok n = fib_is_ok_aux n 0
