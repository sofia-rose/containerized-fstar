module Ex04f

val fold_left:
     ('a -> 'b -> Tot 'b)
  -> list 'a
  -> 'b
  -> Tot 'b
let rec fold_left f lst init = match lst with
  | [] ->  init
  | hd :: tl -> fold_left f tl (f hd init)

val append : list 'a -> list 'a -> Tot (list 'a)
let rec append l1 l2 = match l1 with
  | [] -> l2
  | hd :: tl -> hd :: append tl l2

val reverse: list 'a -> Tot (list 'a)
let rec reverse l =
  match l with
  | [] -> []
  | hd :: tl -> append (reverse tl) [hd]

val append_assoc :
     #a:Type
  -> l1:list a
  -> l2:list a
  -> l3:list a
  -> Lemma (append l1 (append l2 l3) == append (append l1 l2) l3)
let rec append_assoc #a l1 l2 l3 =
  match l1 with
  | [] -> ()
  | h1 :: t1 -> append_assoc t1 l2 l3

let rec fold_left_Cons_is_rev #a (l1 l2: list a) :
  Lemma (fold_left Cons l1 l2 == append (reverse l1) l2) =
  match l1 with
  | [] -> ()
  | h1 :: t1 ->
    // (1) [append (append reverse t1 [h1]) l2
    //      == append (reverse t1) (append [h2] l2)]
    append_assoc (reverse t1) [h1] l2;
    fold_left_Cons_is_rev t1 (h1 :: l2)

