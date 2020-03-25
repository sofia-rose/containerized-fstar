module Ex04g

val hd : l:list 'a{Cons? l} -> Tot 'a
let hd l = match l with
  | x :: _ -> x

val tl : l:list 'a{Cons? l} -> Tot (list 'a)
let tl l = match l with
  | _ :: xs -> xs
