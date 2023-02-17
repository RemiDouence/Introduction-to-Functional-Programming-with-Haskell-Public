# Lab3
```
-- This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
-- https://creativecommons.org/licenses/by-nc-nd/4.0/
-- Remi Douence

-- Please do not distribute solutions but let people learn by doing the exercices.
```
## Key Points
- list comprehension
- goal: https://www.youtube.com/watch?v=Q2wR-joLDMA
- interpeter for arithmetic expressions
## Module Import
- for the last question (best solution) of the session 
```
import Data.List
import Data.Ord
```
## List Comprehension
- `[ exp | pat <- listExp ]` = `for (pat : litExp) { result.add(exp); }`
- `[ exp | pat <- listExp, boolExp ]` = `for (pat : litExp) { if (boolExp) result.add(exp); }`
- `[ exp | pat <- listExp, boolExp, pat2 <- listExp2 ]` = `for (pat : litExp) { if (boolExp) { for (pat2 : listExp2) { result.add(exp); } } }`
```
rectangle :: [(Int,Int)]
rectangle = [ (x,y) | x <- [1..4], y <- [1..5] ]

triangle :: [(Int,Int)]
triangle = undefined 

triangle' :: [(Int,Int)]
triangle' = undefined 

dominos :: [(Int,Int)]
dominos = [ (i,j) | i <- [0..6], j <- [i..6] ]

myQSort :: Ord a => [a] -> [a]
myQSort = undefined 
```
## Goal of the Game
- use at most once each in `[10, 1, 25, 9, 3, 6]` to find an arithmetic expression closest to `595`
### Brute Force
- use at most once each number 
```
-- from Lab2
subLists :: [a] -> [[a]]
subLists []     = [[]]
subLists (x:xs) = ys ++ map (x:) ys
    where ys = subLists xs
```
- insert a number anywhere 
```
injections :: a -> [a] -> [[a]]
injections = undefined 
```
- permutations of numbers
```
permutation :: [a] -> [[a]]
permutation = undefined
```
- permutation of subsets of numbers
```
permutationSubLists :: [a] -> [[a]]
permutationSubLists xs = [zs | ys <- subLists xs, not (null ys), zs <- permutation ys]
```
- where to insert an arithmetic operator 
```
strictPartition :: [a] -> [([a],[a])]
strictPartition = undefined
```
- arithmetic operators 
```
data Op = Add | Sub | Mul | Div deriving Enum -- (Enum, Show)
```
- it is similar to a Java `Enum`
    - `Op` is a new type
    - there are four values `Add`, `Sub`, `Mul` and `Div`
- this is why `True` starts with a capital letter
- `data Bool = True | False`
- pretty print for `Op`
```
instance Show Op where
   show Add = "+"
   show Sub = "-"
   show Mul = "*"
   show Div = "/"
```
- rules of the game
    - positive number only
    - exact division (no remainder)
```
validOp :: Op -> Int -> Int -> Bool
validOp Sub n1 n2 = n1>n2
validOp Div n1 n2 = n1 `mod` n2 == 0
validOp _   _  _  = True
```
- an interpreter for `Op` (from data to computation)
```
evalOp :: Op -> Int -> Int -> Int
evalOp = undefined 
```
- a syntax tree for arithmetic expressions
```
data Exp = Val Int | App Op Exp Exp 
         deriving Show
```
    - `Exp` is a new type
    - `Val` is a new constructor of type `Int -> Exp`
    - `App` is a new constructor of type `Op -> Exp -> Exp -> Exp`
- here is tye type for list: `data List a = Nil | Cons a (List a)`
- enumerate expressions
```
exps :: [Int] -> [Exp]
exps = undefined 
```
- an interpreter of arithmetic expressions
```
evalExp :: Exp -> Int
evalExp (Val n) = n
evalExp (App o g d) = evalOp o (evalExp g) (evalExp d)
```
- an expression id valid if all the operation are valid
```
validExp :: Exp -> Bool
validExp (Val n) = n>0
validExp (App o g d) = validExp g && validExp d && validOp o (evalExp g) (evalExp d)
```
- generate and test algorithm 
```
solutions :: [Int] -> Int -> [Exp]
solutions numbers target =
  let ns = permutationSubLists numbers
      es = concat (map exps ns)
      es' = filter validExp es
  in filter (\e -> evalExp e == target) es'

test1 :: [Exp]
test1 = solutions [1,3,7,10,25,50] 765
```
### Merge generate with filter
- do you actually generate less expressions?
```
exps2 :: [Int] -> [Exp]
exps2 = undefined 
  
solutions2 :: [Int] -> Int -> [Exp]
solutions2 = undefined 

test2 :: [Exp]
test2 = solutions2 [1,3,7,10,25,50] 765
```
### Memoisation (of the evaluation)
- a new type with the value of the expression in the node 
```
data Exp' = Val' Int | App' Op Exp' Exp' Int 
          deriving Show
```
- evaluation becomes an accessor 
```
evalExp' :: Exp' -> Int
evalExp' (Val' n) = n
evalExp' (App' _ _ _ n) = n
```
- `exps3` store the values when the expression is created 
```
exps3 :: [Int] -> [Exp']
exps3 = undefined 

solutions3 :: [Int] -> Int -> [Exp']
solutions3 = undefined 

test3 :: [Exp']
test3 = solutions3 [1,3,7,10,25,50] 765
```
### Symmetry Breaking
- to reduce the search space
```
-- rule 1: no product by 1 
-- rule 2: no division by 1
-- rule 3: addition is commutative (either compute (2 + 3) or compute (3 + 2) but not both)
-- rule 4: product is commutative (either compute (2 * 3) or compute (3 * 2) but not both)
-- these rules can be coded in `alidOp
validOp' :: Op -> Int -> Int -> Bool
validOp' = undefined 

exps4 :: [Int] -> [Exp']
exps4 = undefined 
    
solutions4 :: [Int] -> Int -> [Exp']
solutions4 = undefined 

test4 :: [Exp']
test4 = solutions4 [1,3,7,10,25,50] 765
```
- compare the number of solutions
```
numberOfSolutions3 :: Int
numberOfSolutions3 = length test3

numberOfSolutions4 :: Int
numberOfSolutions4 = length test4
```
### The Best Solution
- best solution = closest to the target
```
distance :: Int -> Exp' -> Int
distance target e = abs (target - evalExp' e)

solutions5 :: [Int] -> Int -> [Exp']
solutions5 = undefined 

test5 :: [Exp']
test5 = solutions5 [1,3,7,10,25,50] 765

test6 :: [Exp']
test6 = solutions5 [1,3,7,10,25,50] 831
```
### Prettier Printer
```
-- infix operations and only mandatory bracket 1+2*(1+2) rather than 1+(2*(1+2))
myShow1 :: Exp -> String
myShow1 = undefined 

test7 :: Exp 
test7 = App Add (Val 1) (App Mul (Val 2) (Val 3))

test8 :: Exp 
test8 = App Mul (App Add (Val 1) (Val 2)) (Val 3)
```
