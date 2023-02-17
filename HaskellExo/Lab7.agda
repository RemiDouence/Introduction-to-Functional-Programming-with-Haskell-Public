
-- This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
-- https://creativecommons.org/licenses/by-nc-nd/4.0/
-- Remi Douence

-- Please do not distribute solutions but let people learn by doing the exercices.

-- H ::= C | v | H -> H | H H  
-- example : Int, a, a -> Int, List (a -> Int)  

-- A ::= C | v | A -> A | A B  
-- B ::= A | v | V | F 
-- example : Int, a, a -> Int, List (a -> Int), List 42, List (odd 42)

-- natural 

data Nat : Set where 
  Z : Nat 
  S : Nat -> Nat 

-- C-L = load 

-- how many types?


-- how many values?


one : Nat 
one = S Z 

two : Nat 
two = S (S Z)

add : Nat -> Nat -> Nat 
add Z n2 = n2
add (S n1) n2 = S (add n1 n2) 

three : Nat 
three = add two one 

-- INCREMENTAL PROGRAMMING: 
-- C-L = load 
-- ? = dig a hole 
-- C-, = print a hole
-- C-C = break a variable
-- C-R = refine hole 
-- C-N = normalize

-- equal algorithm 

data Bool : Set where 
  true : Bool 
  false : Bool

-- how many types?
--EXO
-- 1

-- how many values?


equal : Nat -> Nat -> Bool
equal n1 n2 = ?

test1 : Bool 
test1 = equal two one

test2 : Bool 
test2 = equal two (add one one)

data Equal : Nat -> Nat -> Set where 
  case0 : Equal Z Z 
  case1 : {n1 n2 : Nat} -> Equal n1 n2 -> Equal (S n1) (S n2)

-- how many types?
--EXO
-- infinity: Equal Z Z, Equal (S Z) Z, Equal Z (S Z), Equal (S Z) (S Z), etc.

-- how many values?
--EXO
-- at most one per type

test3 : Equal Z Z
test3 = ?

test4 : Equal (S Z) (S Z)
test4 = ?

test5 : Equal (S (S Z)) (S (S Z))
test5 = ?

test6 : Equal Z (S Z)
test6 = ?

test7 : Equal (S (S Z)) (S Z)
test7 = ?

-- properties of equal 

equal-refl : (n : Nat) -> Equal n n
equal-refl n = ?

equal-sym : {n1 n2 : Nat} -> Equal n1 n2 -> Equal n2 n1
equal-sym p12 = ?


equal-trans : {n1 n2 n3 : Nat} -> Equal n1 n2 -> Equal n2 n3 -> Equal n1 n3
equal-trans p12 p23 = ?





-- properties of add

add-right : (n : Nat) -> Equal (add n Z) n
add-right n = ?

add-assoc : (n1 n2 n3 : Nat) -> Equal (add (add n1 n2) n3) (add n1 (add n2 n3))
add-assoc n1 n2 n3 = ?

-- TODO

add-S : (n1 n2 : Nat) -> Equal (add n1 (S n2)) (S (add n1 n2))
add-S n1 n2 = ?

add-commut : (n1 n2 : Nat) -> Equal (add n1 n2) (add n2 n1)
add-commut n1 n2 = ?

-- iterative addI 

addI : Nat -> Nat -> Nat 
addI Z n2 = n2
addI (S n1) n2 = addI n1 (S n2) 

addI-S : (n1 n2 : Nat) -> Equal (addI n1 (S n2)) (S (addI n1 n2))
addI-S n1 n2 = ?

addI-right : (n : Nat) -> Equal (addI n Z) n
addI-right n = ?

addI-commut : (n1 n2 : Nat) -> Equal (addI n1 n2) (addI n2 n1)
addI-commut n1 n2 = ?

addI-n1 : (n1 n2 n3 : Nat) -> Equal n1 n2 -> Equal (addI n1 n3) (addI n2 n3)
addI-n1 n1 n2 n3 = ?

addI-assoc : (n1 n2 n3 : Nat) -> Equal (addI (addI n1 n2) n3) (addI n1 (addI n2 n3))
addI-assoc n1 n2 n3 = ?

-- equivalence of addition functions (add as a pivot for properties)

addI-add : (n1 n2 : Nat) -> Equal (addI n1 n2) (add n1 n2)
addI-add n1 n2 = ?

addI-commut' : (n1 n2 : Nat) -> Equal (addI n1 n2) (addI n2 n1)
addI-commut' n1 n2 = ?


addR : Nat -> Nat -> Nat 
addR n1 Z = n1
addR n1 (S n2) = S (addR n1 n2) 

-- TODO : prove addR Z n = n, addR assoc, addR commut, addR = add 
