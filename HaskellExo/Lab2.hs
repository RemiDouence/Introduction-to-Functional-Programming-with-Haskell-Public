
-- This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
-- https://creativecommons.org/licenses/by-nc-nd/4.0/
-- Remi Douence

-- Please do not distribute solutions but let people learn by doing the exercices.

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

l3 = True:l1

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

{-
class Eq a where
  (==) :: a -> a -> Bool
  x == y = not (x/=y)
  (/=) :: a -> a -> Bool
  x /= y = not (x==y)
-}

{-
class Eq a => Ord a where
  (>) :: a -> a -> Bool
  (>=) :: a -> a -> Bool
  x >= y = x==y || x>y
-}

{-
instance Eq Bool where
  True  == True  = True
  False == False = True
  _     == _     = False

instance Eq Int where
  x == y = Processeur.cmp x y 
-}

{-
instance Eq a => Eq [a] where
  []     == []     = True
  (x:xs) == (y:ys) = x==y && xs==ys
  _      == _      = False 
-}

mySort :: [Int] -> [Int]

mySort (x:xs) = myInsert x (mySort xs)
mySort []     = []

-- yet another very bad (worse) definition 
myNull'' :: [Int] -> Bool

myNull'' xs = xs==[]

myTakeWhile :: (a -> Bool) -> [a] -> [a]
myTakeWhile f xs = undefined 

-- (2>) waits for its second argument 
-- (>2) waits for its first argument 

-- myHead :: [Int] -> Int moins general myHead :: [a] -> a 

--myCompose :: ?  

myCompose f g x = f (g x)
-- myCompose is predefined as (.) as  in f . g 

myMap :: (a -> b) -> [a] -> [b]
myMap = undefined

test1 :: [Bool]
test1 = myMap odd [1..10]


subLists :: [a] -> [[a]]
subLists = undefined 

--myFoldr : ?

myFoldr f k (x:xs) = x `f` (myFoldr f k xs)
myFoldr f k []     = k

myAnd' :: [Bool] -> Bool
myAnd' = foldr (&&) True
-- you should draw a list

-- on the right hand side of `=` an anonymous function 
c42 :: Int 
c42 = (\f x -> f (f x)) ((\f x -> f (f x)) (2*)) 1

s1 :: String -- [Char]
s1 = "a sequence of characters"

myFst :: (a,b) -> a
myFst (x,y) = x

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
mySplitAt = indefined 

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

-- modulo for intergers
m1 :: Bool
m1 = 14 `mod` 3 == 2

sieve :: [Int] -> [Int]
sieve = undefined 

primes :: [Int]
primes = sieve [2..]

first50 :: [Int]
first50 = take 50 primes 
