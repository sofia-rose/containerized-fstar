module Ex04b

val length : list 'a -> Tot nat
let rec length l = match l with
  | [] -> 0
  | _ :: tl -> 1 + length tl

val append : list 'a -> list 'a -> Tot (list 'a)
let rec append l1 l2 = match l1 with
  | [] -> l2
  | hd :: tl -> hd :: append tl l2

val append_length_sum:
    xs:list 'a
 -> ys:list 'a
 -> Lemma (length (append xs ys) = length xs + length ys)
let rec append_length_sum xs ys = match xs with
  | [] -> ()
  | hd :: tl -> append_length_sum tl ys
