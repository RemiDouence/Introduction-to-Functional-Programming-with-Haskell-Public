# Lab2
```
-- This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
-- https://creativecommons.org/licenses/by-nc-nd/4.0/
-- Remi Douence

-- Please do not distribute solutions but let people learn by doing the exercices.
```
## Key Points
- genericity
- ad hoc polymorphism
- higher order 
- most general type 
- anonymous function 
- `Char` and `String`
- tuples 
## Generalize types in Lab1
- a type variable starts with a lower case letter
```
myHead :: [Int] -> Int

myHead (x:_) = x

myTail :: [Int] -> [Int]

myTail (_:xs) = xs

myAppend :: [Int] -> [Int] -> [Int]

myAppend xs ys = myAppend' xs 
    where myAppend' (x:xs) = x:myAppend' xs
          myAppend' [] = ys  

myInit :: [Int] -> [Int]

myInit [_]    = []
myInit (x:xs) = x:myInit xs

myLast :: [Int] -> Int

myLast [x] = x
myLast (_:xs) = myLast xs

myNull :: [Int] -> Bool

myNull [] = True
myNull _  = False

l1 :: [Int]

l1 = []

l2 :: [Int]

l2 = 1:l1

l3 :: [Bool]

l3 = undefined -- True:l1

myLength :: [Int] -> Int

myLength (_:xs) = 1 + myLength xs
myLength []     = 0

-- a very bad definition
myNull' :: [Int] -> Bool

myNull' xs = length xs==0

myReverse :: [Int] -> [Int]

myReverse (x:xs) = myReverse xs ++ [x]
myReverse []     = []

myConcat :: [[Int]] -> [Int]

myConcat (bs:bss) = bs ++ myConcat bss
myConcat [] = []

myTake :: Int -> [Int] -> [Int]

myTake 0 _  = []
myTake n [] = []
myTake n (x:xs) = x:myTake (n-1) xs

myDrop :: Int -> [Int] -> [Int]

myDrop 0 xs = xs
myDrop n [] = []
myDrop n (x:xs) = myDrop (n-1) xs

myBangBang :: [Int] -> Int -> Int -- (!!)

myBangBang (x:xs) 0 = x
myBangBang (x:xs) n = myBangBang xs (n-1)

myInsert :: Int -> [Int] -> [Int]

myInsert x [] = [x]
myInsert x (y:ys) | x>y       = y:myInsert x ys
                  | otherwise = x:y:ys
```
## ad hoc Polymorphism
- disclaimer:
    - 1990 Haskell https://en.wikipedia.org/wiki/Haskell
    - 1995 Java https://en.wikipedia.org/wiki/Java_(programming_language)
    - so don't tell me Java classes are the right ones
    - in fact people from Haskell have introduced genericty to Java https://homepages.inf.ed.ac.uk/wadler/gj/
- an Haskell `class`= a Java interface
    - default definition = Java default methods in interface
    - class inheritance `=>` = Java interface inheritance 
- `class Eq` https://hackage.haskell.org/package/base-4.17.0.0/docs/Prelude.html#t:Eq
```
{-
class Eq a where
  (==) :: a -> a -> Bool
  x == y = not (x/=y)
  (/=) :: a -> a -> Bool
  x /= y = not (x==y)
-}
```
- `class Ord` https://hackage.haskell.org/package/base-4.17.0.0/docs/Prelude.html#t:Ord
```
{-
class Eq a => Ord a where
  (>) :: a -> a -> Bool
  (>=) :: a -> a -> Bool
  x >= y = x==y || x>y
-}
```
- an Haskell `instance` = a Java class implementing a interface 
```
{-
instance Eq Bool where
  True  == True  = True
  False == False = True
  _     == _     = False

instance Eq Int where
  x == y = Processeur.cmp x y 
-}
```
- dependencies `Eq a => Eq [a]`
```
{-
instance Eq a => Eq [a] where
  []     == []     = True
  (x:xs) == (y:ys) = x==y && xs==ys
  _      == _      = False 
-}
```
- we will only use a few classes
    - `Eq`: for equality (`equals` in Java)
    - `Ord`: for order (`Comparable` in Java)
    - `Show`: provide a function `show :: a -> String` (`toString` in Java) 
```
mySort :: [Int] -> [Int]

mySort (x:xs) = myInsert x (mySort xs)
mySort []     = []

-- yet another very bad (worse) definition 
myNull'' :: [Int] -> Bool

myNull'' xs = xs==[]
```
## New Stuff: Higher Order
- a function is a first class citizen
- a function can be a parameter
- a function can be a result (e.g., `myNeg'` in Lab1)
- brackets are important in types 
```
myTakeWhile :: (a -> Bool) -> [a] -> [a]
myTakeWhile f xs = undefined 
```
### Section
- a section is a partialy applied infix binary function 
```
-- (2>) waits for its second argument 
-- (>2) waits for its first argument 
```
## New Stuff: Most General Type
```
-- myHead :: [Int] -> Int moins general myHead :: [a] -> a 
```
- give the most general type `myCompose`
```
--myCompose :: ?  

myCompose f g x = f (g x)
-- myCompose is predefined as (.) as  in f . g 
```
give the most natural definition of myMap
```
myMap :: (a -> b) -> [a] -> [b]
myMap = undefined

test1 :: [Bool]
test1 = myMap odd [1..10]

```
- use `map` to compute `SubLists`
```
subLists :: [a] -> [[a]]
subLists = undefined 
```
- `foldr` is a very usefull function for list 
```
--myFoldr : ?

myFoldr f k (x:xs) = x `f` (myFoldr f k xs)
myFoldr f k []     = k
```
- `foldr` "replaces" `:` by `f`
- `foldr` "replaces" `[]` by `k` 
```
myAnd' :: [Bool] -> Bool
myAnd' = foldr (&&) True
-- you should draw a list
```
## New Stuff: Anonymous Function
- you do not want to invent a name for a disposable function
- you can capture values in its definition
- this is similar to anonymous classes in Java for AWT listeners
```
-- on the right hand side of `=` an anonymous function 
c42 :: Int 
c42 = (\f x -> f (f x)) ((\f x -> f (f x)) (2*)) 1
```
## New Stuff: `String`
- `String` is a type synonym for [Char]
- how many characters? `length`
- first character? `head`
- "don't nod" palindrome? `\s -> s == reverse s`
```
s1 :: String -- [Char]
s1 = "a sequence of characters"
```
## New Stuff: Tuples
- the type of a pair `(Int,Bool)` has exactly two components
- use pattern matching to access the components
```
myFst :: (a,b) -> a
myFst (x,y) = x
```
- tuples are generalized to any type and arity: triplet `(Int,String,Bool)`, quadruplet, etc.
## TODO 
```
myDropWhile :: (a -> Bool) -> [a] -> [a]
myDropWhile = undefined 

--with only two equations
myElem :: Eq a => a -> [a] -> Bool
myElem = undefined

myNotElem :: Eq a => a -> [a] -> Bool
myNotElem = undefined 

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter = undefined 

-- you can use pattern matching such as `where (ls, rs) = exp`
mySplitAt :: Int -> [a] -> ([a],[a])
mySplitAt = undefined 

myZip :: [a] -> [b] -> [(a,b)]
myZip = undefined 

myZipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
myZipWith = undefined

myCurry :: ((a,b) -> c) -> a -> b -> c
myCurry = undefined

myUncurry :: (a -> b -> c) -> (a,b) -> c
myUncurry f (x,y) = f x y

myUnzip :: [(a,b)] -> ([a],[b])
myUnzip = undefined 

-- define myZipWith NON recursively
myZipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
myZipWith' = undefined
```
## `foldr`
```
-- define the following function with a `foldr`

myConcat' :: [[a]] -> [a]
myConcat' = undefined 

myMap' ::  (a -> b) -> [a] -> [b]
myMap' = undefined 

myOr' ::  [Bool] -> Bool
myOr' = undefined 

myAny :: (a -> Bool) -> [a] -> Bool
myAny = undefined 

myAll :: (a -> Bool) -> [a] -> Bool
myAll = undefined 

myProduct :: [Int] -> Int
myProduct = undefined 

mySum :: [Int] -> Int
mySum = undefined 

mySort' :: Ord a => [a] -> [a]
mySort' = undefined 

myReverse' :: [a] -> [a]
myReverse' = undefined 
```
## Prime Number Sieve
- compute the first 50 prime numbers 2, 3, 5, 7, 11...
- the sieve filters out the mutiples of 2, of 3, of 5, of 7, of 11...
```
-- modulo for intergers
m1 :: Bool
m1 = 14 `mod` 3 == 2

sieve :: [Int] -> [Int]
sieve = undefined 

primes :: [Int]
primes = sieve [2..]

first50 :: [Int]
first50 = take 50 primes 
```
