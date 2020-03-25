module Ex04a

val length : list 'a -> Tot nat
let rec length l = match l with
  | [] -> 0
  | _ :: tl -> 1 + length tl

val append : x:list 'a -> y:list 'a -> Tot (z:list 'a{length z = length x + length y})
let rec append l1 l2 = match l1 with
  | [] -> l2
  | hd :: tl -> hd :: append tl l2
