# Lab4 Exam
```
-- This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
-- https://creativecommons.org/licenses/by-nc-nd/4.0/
-- Remi Douence

-- Please do not distribute solutions but let people learn by doing the exercices.
```
## This is an exam of previous years so that you can practise
```

-- PLEASE FILL IN YOUR IDENTITY BELOW AND CHANGE MY NAME BY YOURS IN THE FILENAME
-- NOM : DOUENCE
-- PRENOM : REMI

-- you cannot change this file (no new definition)
-- you can only replace undefined by your definition
-- constraints : 
-- [REC]: your definition is a function that calls itself
-- [NOREC]: your definition is a function that does not call itself
-- [ZF]: you definition contains a list comprehension 

-- you can only use: (==), (/=), (+), (<=), (:), (.), (++), filter, foldr, length, map

-- huffman compressor 
example1 :: String
example1 = "abcbcaa"

-- Huffman tree

data Huff a = Leaf a | Node (Huff a) (Huff a) deriving (Show,Eq)

-- path in a tree 

type Bits = [Bit]

data Bit = L | R deriving (Show,Eq)

-- build the huffman tree

-- Q1 [REC]
-- compute the number of occurrences of characters

testQ1 :: Bool
testQ1 = nbOccurrences example1 == [('a',3),('b',2),('c',2)]

nbOccurrences :: String -> [(Char,Int)]
nbOccurrences = undefined 

-- Q2 [REC]
-- the weight is the sum of number of occurrences

testQ2 :: Bool
testQ2 = weight (Node (Leaf ('a',3)) (Node (Leaf ('b',2)) (Leaf ('c',2)))) == 7

weight :: Huff (a,Int) -> Int
weight = undefined 
        
-- Q3 [REC]
-- insert a tree in a list of sorted trees (incresing weight)

testQ3 :: Bool
testQ3 = insert (Leaf ('a',3)) [Leaf ('b',2),Leaf ('c',2)] == [Leaf ('b',2),Leaf ('c',2),Leaf ('a',3)]

insert :: Huff (a,Int) -> [Huff (a,Int)] -> [Huff (a,Int)]
insert = undefined 
         
-- Q4 [NOREC but a foldr]
-- sort a list of trees by increasing weight

testQ4 :: Bool
testQ4 = sort [Leaf ('a',3),Leaf ('b',2),Leaf ('c',2)] == [Leaf ('b',2),Leaf ('c',2),Leaf ('a',3)]

sort :: [Huff (a,Int)] -> [Huff (a,Int)]
sort = undefined 
          
-- Q5 [non REC]
-- return the list of leaves for a String

testQ5 :: Bool
testQ5 = leaves example1 == [Leaf ('b',2),Leaf ('c',2),Leaf ('a',3)]

leaves :: String -> [Huff (Char,Int)]
leaves = undefined 

-- Q6 [REC]
-- aggregate the two lighter trees, over and over again until there is only one tree

testQ6 :: Bool
testQ6 = aggregate [Leaf ('b',2),Leaf ('c',2),Leaf ('a',3)] == Node (Leaf ('a',3)) (Node (Leaf ('b',2)) (Leaf ('c',2)))

aggregate :: [Huff (a,Int)] -> Huff (a,Int)
aggregate = undefined 
         
-- Q7 [REC]
-- strip the number of occurrences in a tree

testQ7 :: Bool
testQ7 = strip (Node (Leaf ('a',3)) (Node (Leaf ('b',2)) (Leaf ('c',2)))) == Node (Leaf 'a') (Node (Leaf 'b') (Leaf 'c'))

strip :: Huff (a,Int) -> Huff a
strip = undefined
        
-- return the huffman tree for a String

test' :: Bool
test' = buildHuff example1 == Node (Leaf 'a') (Node (Leaf 'b') (Leaf 'c'))

buildHuff :: String -> Huff Char 
buildHuff = strip . aggregate . leaves


-- compress a String

-- code one Char

test'' :: Bool
test'' = codeOne (Node (Leaf 'a') (Node (Leaf 'b') (Leaf 'c'))) 'b' == [R,L]

codeOne :: Huff Char -> Char -> Bits
codeOne root c = head (codeOne' root c)

-- Q8 [REC and use map]
-- return the list onf length 1 that contains the path from the root to the character 
-- start by coding the function that returns all possible paths, then modify it

testQ8 :: Bool
testQ8 = codeOne' (Node (Leaf 'a') (Node (Leaf 'b') (Leaf 'c'))) 'b' == [[R,L]]

codeOne' :: Huff Char -> Char -> [Bits]
codeOne' = undefined 
           
-- code all characters of a String

test''' :: Bool
test''' = codeAll (Node (Leaf 'a') (Node (Leaf 'b') (Leaf 'c'))) example1 == [L,R,L,R,R,R,L,R,R,L,L]

codeAll :: Huff Char -> String -> Bits
codeAll root s = concat (map (codeOne root) s)


-- Q9 [REC]
-- uncompress a list of bits

testQ9 :: Bool
testQ9 = decode (Node (Leaf 'a') (Node (Leaf 'b') (Leaf 'c'))) (Node (Leaf 'a') (Node (Leaf 'b') (Leaf 'c'))) [L,R,L,R,R,R,L,R,R,L,L] == "abcbcaa"

decode :: Huff Char -> Huff Char -> Bits -> String
decode = undefined 

-- check correctness (decode . code) == id and compute the ratio

test'''' :: Bool
test'''' = test10 example1 == (True,0.19642857)

test10 :: String -> (Bool,Float)
test10 s = 
    let t = buildHuff s
        c = codeAll t s
        s' = decode t t c
    in (s==s',(fromIntegral (length c))/(fromIntegral (8*length s)))

-- Q10 
-- question: what is computed numerous times and could be optimized ? (answer with at most 10 words)


```
