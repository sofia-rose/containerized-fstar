module Ex04d

val append: list 'a -> list 'a -> Tot (list 'a)
let rec append l1 l2 = match l1 with
  | [] -> l2
  | hd :: tl -> hd :: append tl l2

val reverse: list 'a -> Tot (list 'a)
let rec reverse l =
  match l with
  | [] -> []
  | hd :: tl -> append (reverse tl) [hd]

let snoc l h = append l [h]

val snoc_cons: l:list 'a -> h:'a -> Lemma (reverse (snoc l h) == h :: reverse l)
let rec snoc_cons l h = match l with
  | [] -> ()
  | hd :: tl ->
    // (H1) [reverse (snoc tl h) == h :: reverse tl]
    snoc_cons tl h
    // (1) reverse (snoc (hd :: tl) h)
    // (2) =def(snoc)= reverse (append (hd :: tl) [h])
    // (3) =def(append)= reverse (hd :: append tl [h])
    // (4) =def(reverse)= append (reverse (append tl [h]) [hd]
    // (5) =def(snoc)= append (reverse (snoc tl h)) [hd]
    // (6) =(H1)= append (h :: reverse tl) [hd]
    // (7) =def(append)= h :: append (reverse tl) [hd]
    // (8) =def(reverse)= h :: reverse (hd :: tl)
    // Are we allowed to use the definition of reverse backwards as in (8)?

val rev_involutive: l:list 'a -> Lemma (reverse (reverse l) == l)
let rec rev_involutive l = match l with
  | [] -> ()
  | hd :: tl ->
    // (H1) [reverse (reverse tl) == tl]
    rev_involutive tl;
    // (H2) [reverse (append (reverse tl) [hd] == hd :: reverse (reverse tl)]
    snoc_cons (reverse tl) hd
    // (1) reverse (reverse (hd :: tl))
    // (2) =def(reverse)= reverse (append (reverse tl) [hd])
    // (3) =def(snoc)= reverse (snoc (reverse tl) hd)
    // (4) =(H2)= hd :: reverse (reverse tl)
    // (5) =(H1)= hd :: tl
    // (6_ =(def)= l

val snoc_injective:
     l1:list 'a
  -> h1: 'a
  -> l2:list 'a
  -> h2: 'a
  -> Lemma (requires (snoc l1 h1 == snoc l2 h2))
           (ensures l1 == l2 /\ h1 == h2)
let rec snoc_injective l1 h1 l2 h2 = match l1, l2 with
  | hd1::tl1, hd2::tl2 ->
    snoc_injective tl1 h1 tl2 h2
    // TODO: state this proof by hand
  | _ -> ()

val rev_injective:
    l1:list 'a
  -> l2: list 'a
  -> Lemma (requires (reverse l1 == reverse l2))
           (ensures (l1 == l2))
let rec rev_injective l1 l2 =
  match l1, l2 with
  | h1::t1, h2::t2 ->
    snoc_injective (reverse t1) h1 (reverse t2) h2;
    rev_injective t1 t2
    // TOOD: state this proof by hand
  | _, _ -> ()


val rev_injective2:
    l1:list 'a
  -> l2: list 'a
  -> Lemma (requires (reverse l1 == reverse l2))
           (ensures (l1 == l2))
let rev_injective2 l1 l2 =
  rev_involutive l1; rev_involutive l2
  // TODO: state this proof by hand
