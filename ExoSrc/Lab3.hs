
-- This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
-- https://creativecommons.org/licenses/by-nc-nd/4.0/
-- Remi Douence

-- Please do not distribute solutions but let people learn by doing the exercices.

import Data.List
import Data.Ord

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

-- from Lab2
subLists :: [a] -> [[a]]
subLists []     = [[]]
subLists (x:xs) = ys ++ map (x:) ys
    where ys = subLists xs

injections :: a -> [a] -> [[a]]
injections = undefined 

permutation :: [a] -> [[a]]
permutation = undefined

permutationSubLists :: [a] -> [[a]]
permutationSubLists xs = [zs | ys <- subLists xs, not (null ys), zs <- permutation ys]

strictPartition :: [a] -> [([a],[a])]
strictPartition = undefined

data Op = Add | Sub | Mul | Div deriving Enum -- (Enum, Show)

instance Show Op where
   show Add = "+"
   show Sub = "-"
   show Mul = "*"
   show Div = "/"

validOp :: Op -> Int -> Int -> Bool
validOp Sub n1 n2 = n1>n2
validOp Div n1 n2 = n1 `mod` n2 == 0
validOp _   _  _  = True

evalOp :: Op -> Int -> Int -> Int
evalOp = undefined 

data Exp = Val Int | App Op Exp Exp 
         deriving Show

exps :: [Int] -> [Exp]
exps = undefined 

evalExp :: Exp -> Int
evalExp (Val n) = n
evalExp (App o g d) = evalOp o (evalExp g) (evalExp d)

validExp :: Exp -> Bool
validExp (Val n) = n>0
validExp (App o g d) = validExp g && validExp d && validOp o (evalExp g) (evalExp d)

solutions :: [Int] -> Int -> [Exp]
solutions numbers target =
  let ns = permutationSubLists numbers
      es = concat (map exps ns)
      es' = filter validExp es
  in filter (\e -> evalExp e == target) es'

test1 :: [Exp]
test1 = solutions [1,3,7,10,25,50] 765

exps2 :: [Int] -> [Exp]
exps2 = undefined 
  
solutions2 :: [Int] -> Int -> [Exp]
solutions2 = undefined 

test2 :: [Exp]
test2 = solutions2 [1,3,7,10,25,50] 765

data Exp' = Val' Int | App' Op Exp' Exp' Int 
          deriving Show

evalExp' :: Exp' -> Int
evalExp' (Val' n) = n
evalExp' (App' _ _ _ n) = n

exps3 :: [Int] -> [Exp']
exps3 = undefined 

solutions3 :: [Int] -> Int -> [Exp']
solutions3 = undefined 

test3 :: [Exp']
test3 = solutions3 [1,3,7,10,25,50] 765

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

numberOfSolutions3 :: Int
numberOfSolutions3 = length test3

numberOfSolutions4 :: Int
numberOfSolutions4 = length test4

distance :: Int -> Exp' -> Int
distance target e = abs (target - evalExp' e)

solutions5 :: [Int] -> Int -> [Exp']
solutions5 = undefined 

test5 :: [Exp']
test5 = solutions5 [1,3,7,10,25,50] 765

test6 :: [Exp']
test6 = solutions5 [1,3,7,10,25,50] 831

-- infix operations and only mandatory bracket 1+2*(1+2) rather than 1+(2*(1+2))
myShow1 :: Exp -> String
myShow1 = undefined 

test7 :: Exp 
test7 = App Add (Val 1) (App Mul (Val 2) (Val 3))

test8 :: Exp 
test8 = App Mul (App Add (Val 1) (Val 2)) (Val 3)
