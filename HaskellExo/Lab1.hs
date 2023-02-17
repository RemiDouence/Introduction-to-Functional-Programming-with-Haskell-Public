
-- This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
-- https://creativecommons.org/licenses/by-nc-nd/4.0/
-- Remi Douence

-- Please do not distribute solutions but let people learn by doing the exercices.

import Data.List

-- single line comment 
{- multi lines comment 
{- nested comment -}
-}

c1 :: Int 

c1 = 1 

c2 :: Int
c2 = 2+1

c3 :: Int
c3 = (+) 2 1 

mySub :: Int -> Int -> Int
mySub    x       y      = x - y 

mySub' :: Int -> (Int -> Int)
mySub'    x       y      = x - y 

myNeg :: Int -> Int
myNeg x = mySub 0 x 

myNeg' :: Int -> Int
myNeg' = mySub 0 

b1 :: Bool
b1 = True

b2 :: Bool
b2 = (b1 && False) || not b1

b3 :: Bool
b3 = 1>2 

b4 :: Bool
b4 = 1==2

b5 :: Bool -- not equal
b5 = 1/=2

l1 :: [Int]
l1 = []

l2 :: [Int]
l2 = 11 : 12 : l1

myCons :: Int -> [Int] -> [Int]
myCons = (:)

myNil :: [Int]
myNil = []

l5 :: [Int]
l5 = [1..10]

l6 :: [Int]
l6 = [1,3..10]

l7 :: [Int]
l7 = [10,8..3]

myHead :: [Int] -> Int
myHead (x:xs) = x

myTail :: [Int] -> [Int]
myTail (_:xs) = xs

myAppend :: [Int] -> [Int] -> [Int]
myAppend = undefined

myAppend' :: [Int] -> [Int] -> [Int]
myAppend' xs ys | not (null xs) = head xs : myAppend' (tail xs) ys
                | otherwise     = ys

myAppend'' :: [Int] -> [Int] -> [Int]
myAppend'' xs ys | null xs       = ys
                 | not (null xs) = head xs : myAppend'' (tail xs) ys

myAppend4 :: [Int] -> [Int] -> [Int]
myAppend4 (x:xs) ys = 
    let suite = myAppend4 xs ys 
    in x:suite
myAppend4 []     ys = ys

myAppend5 :: [Int] -> [Int] -> [Int]
myAppend5 (x:xs) ys = x:suite where suite = myAppend5 xs ys
myAppend5 []     ys = ys

myAppend6 :: [Int] -> [Int] -> [Int]
myAppend6 xs ys = myAppend6' xs 
    where myAppend6' :: [Int] -> [Int]
          myAppend6' (x:xs) = x:myAppend6' xs
          myAppend6' []     = ys

myInit :: [Int] -> [Int]
myInit = undefined 

myLast :: [Int] -> Int
myLast = undefined

myNull :: [Int] -> Bool
myNull = undefined

myLength :: [Int] -> Int
myLength = undefined

myNull' :: [Int] -> Bool -- an alternative definition
myNull' = undefined

myReverse :: [Int] -> [Int]
myReverse = undefined

-- propose a more efficient (less complex) definition
myReverse' :: [Int] -> [Int]
myReverse' = undefined

myConcat :: [[Int]] -> [Int]
myConcat = undefined

myAnd :: [Bool] -> Bool
myAnd = undefined

myOr ::  [Bool] -> Bool
myOr = undefined

myProduct :: [Int] -> Int
myProduct = undefined

myTake :: Int -> [Int] -> [Int]
myTake = undefined

myDrop :: Int -> [Int] -> [Int]
myDrop = undefined

-- the corresponding predefined infix function is named !! 
myBangBang :: [Int] -> Int -> Int
myBangBang = undefined

-- we assume the argument is a list of ordered (increasing) integers
myInsert :: Int -> [Int] -> [Int]
myInsert = undefined

mySort :: [Int] -> [Int]
mySort = undefined
