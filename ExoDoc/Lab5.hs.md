# Lab5
```
-- This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
-- https://creativecommons.org/licenses/by-nc-nd/4.0/
-- Remi Douence

-- Please do not distribute solutions but let people learn by doing the exercices.
```
## Purely Functional Data Structure
- functional programming is a paradigm
- you do not program in Haskell hte same way you program in Java
- yet some functional idioms can be used in Java (for instance for concurrent programming)
### Definition
- what is a purely functional data structure?
- when you "modify" a data structure, you get a modified copy of the data structure.
the original one has not changed. this is the only way to do in
haskell. remember the type list []. remember the list of random
integer in quickcheck (the new version is returned). in general it
can make programming simpler. because of local reasonning, where
side effects requires global reasonning (who has accessed the data
structure before me, between two of my accesses?)
### List
```
-- list promotes left access / construction

data List a = Nil | Cons a (List a) deriving (Show,Eq) -- the recursion is in the second arg of Cons

list1 :: List Int
list1 = Cons 1 (Cons 2 (Cons 3 Nil))

-- head/tail are O(1)

myHead :: List a -> a
myHead (Cons x xs) = x

myTail :: List a -> List a
myTail (Cons x xs) = xs

-- init/last are O(n) where n = length xs

myLast :: List a -> a
myLast (Cons x Nil) = x
myLast (Cons x xs)  = myLast xs

myInit :: List a -> List a
myInit (Cons x Nil) = Nil
myInit (Cons x xs)  = Cons x (myInit xs)

myAppend :: List a -> List a -> List a
myAppend (Cons x xs) ys = Cons x (myAppend xs ys)
myAppend Nil         ys = ys
```
### Tsil (list from the right)
```
-- promote right access when an algorithm is more right oriented that left oriented

-- Tsil promotes right access / construction

data Tsil a = Lin | Snoc (Tsil a) a deriving (Show,Eq) -- the recursion is in the first param of Snoc

tsil1 :: Tsil Int
tsil1 = Snoc (Snoc (Snoc Lin 1) 2) 3

-- tsal/tini are O(1)

myTsal :: Tsil a -> a
myTsal (Snoc xs x) = x

myTini :: Tsil a -> Tsil a
myTini (Snoc xs x) = xs

-- but deah/liat are O(n)

myDeah :: Tsil a -> a
myDeah (Snoc Lin x) = x
myDeah (Snoc xs  x) = myDeah xs

myLiat :: Tsil a -> Tsil a
myLiat (Snoc Lin x) = Lin
myLiat (Snoc xs  x) = Snoc (myLiat xs) x

myDneppa :: Tsil a -> Tsil a -> Tsil a
myDneppa xs Lin = xs
myDneppa xs (Snoc ys y) = Snoc (myDneppa xs ys) y

```
### Purely Functional Queue 
```
-- purely functional queue

type Queue1 a = [a]

isEmpty1 :: Queue1 a -> Bool
isEmpty1 = null -- O(1)

enQueue1 :: a -> Queue1 a -> Queue1 a 
enQueue1 = (:) -- O(1)

deQueue1 :: Queue1 a -> (a,Queue1 a)
deQueue1 xs = (last xs,init xs) -- O(n) where n = length xs

-- if we evaluate the complexity of a sequence: n * enqueue ; n * dequeue


```
### Zipper
- move a cursor in a data structure and edit it
```
-- list zipper for editable list

type ListZ a = ([a],[a])

mkZipL :: [a] -> ListZ a
mkZipL xs = ([],xs)

unzipL :: ListZ a -> [a]
unzipL (ls,rs) = reverse ls ++ rs

goNext :: ListZ a -> ListZ a  -- O(1)
goNext (ls,cursor:rs) = (cursor:ls,rs)

goPrevious :: ListZ a -> ListZ a -- O(1)
goPrevious (cursor:ls,rs) = (ls,cursor:rs)

transfoElt :: (a -> a) -> ListZ a -> ListZ a  -- O(1)
transfoElt f (cursor:ls,rs) = (f cursor:ls,rs)
```
### Rose Tree
- a rose tree has a variable arity (variable number of subtrees)
```
-- n-ary tree depth first 

data Rose a = Rose a (Forest a) deriving (Show, Eq)

type Forest a = [Rose a]

label :: Rose a -> a
label (Rose a ts) = a

subTree :: Rose a -> Forest a
subTree (Rose a ts) = ts

```
- its is more general to return a list of subtrees than a list of label
- a simple `map label` will get you the sequence of labels
```
dfs :: Rose a -> Forest a
dfs t = t:concat (map dfs (subTree t))
```
### TODO: `Seq`
```
-- TODO 1: a third representation for list, Seq promotes concatenation

data Seq a = None | One a | Join (Seq a) (Seq a) deriving (Show,Eq) -- the recursion is in both params of Join

-- maintain a normal form: there is no None in a non empty Seq

myHeadS :: Seq a -> a
myHeadS = undefined 

myTailS :: Seq a -> Seq a
myTailS (Join l r) = myTailS l `Join` r
myTailS (One x) = None -- beware not a normal form...

myTailS' :: Seq a -> Seq a
myTailS' = undefined 

myInitS :: Seq a -> Seq a
myInitS = undefined 

myLastS :: Seq a -> a
myLastS = undefined 

myAppendS :: Seq a -> Seq a -> Seq a
myAppendS = undefined 

myReverseS :: Seq a -> Seq a
myReverseS = undefined 

mySingletonS :: Seq a -> Bool
mySingletonS = undefined 

-- write a test
```
### TODO: Simple and Efficient Queue (Okasaki)
```
-- TODO 2: purely functional queue

type Queue2 a = ([a],[a])

isEmpty2 :: Queue2 a -> Bool -- O(n)
isEmpty2 (xs,ys) = null xs && null ys

enQueue2 :: a -> Queue2 a -> Queue2 a -- O(1)
enQueue2 x (xs,ys) = (x:xs,ys) 

deQueue2 :: Queue2 a -> (a,Queue2 a) -- O(1) or O(n) where n = length xs
deQueue2 (xs,y:ys) = (y,(xs,ys))
deQueue2 (xs,[]) = undefined

-- if we evaluate the complexity of a sequence:
-- n * enqueue ; n * dequeue: O(?) 

-- write a test
```
### TODO : Tree Zipper 
```
-- TODO 3: tree zipper for editable tree (zipper can be defined for any structure)

data Tree a = Node (Tree a) (Tree a) | Leaf a deriving (Show,Eq)

data Ctx a = NodeL (Ctx a) (Tree a) | NodeR (Tree a) (Ctx a) | Here deriving (Show,Eq)

type TreeZ a = (Tree a,Ctx a)

mkZipT :: Tree a -> TreeZ a
mkZipT t = (t,Here)

goLeft :: TreeZ a -> TreeZ a -- O(1)
goLeft = undefined 

goRight :: TreeZ a -> TreeZ a -- O(1)
goRight = undefined 

goUp :: TreeZ a -> TreeZ a -- O(1)
goUp = undefined 

transfoTree :: (Tree a -> Tree a) -> TreeZ a -> TreeZ a -- O(1)
transfoTree f (t,c) = (f t,c)

setLeftMost :: a -> TreeZ a -> TreeZ a
setLeftMost = undefined 

test462 = fst (setLeftMost 0 (mkZipT (Node (Node (Leaf 1) (Leaf 2)) (Node (Leaf 3) (Leaf 4)))))
```
### TODO: Breadth First Visitor
```
-- TODO 4: a tree breadth first 

bfs :: Forest a -> Forest a
bfs = undefined 

t1 :: Rose Int
t1 = Rose 1 [Rose 2 [Rose 4 []],Rose 3 []]

-- write a test
```
### TODO: Map
```
-- TODO 5: a Map from key to value
-- where keys are sorted in Fork l (k,a) r: (all keys of l <= k) && (k < all keys of r)

data Map k a = Tip | Fork (Map k a) (k,a) (Map k a)
  deriving (Show,Eq)

emptyMap :: Map k a
emptyMap = Tip

lookupMap :: Ord k => k -> Map k a -> a -- O(n) where n = size map (but O(log n) if balanced trees)
lookupMap k (Fork l (k',x) r)
  | k==k' = x
  | k< k' = lookupMap k l
  | k> k' = lookupMap k r

insertMap :: Ord k => (k,a) -> Map k a -> Map k a -- update if k already exists
insertMap = undefined 

-- write test
```
### TODO: Random Access List
- list + array = random access list
```
-- TODO 6: study the code and the complexity of the following data structure
-- both a list and an array (purely functional random-access list, kris okasaki, 1995)

-- we assume trees are complete

data CTree a = CNode (CTree a) a (CTree a) | CLeaf a deriving (Show,Eq)

-- tree random access

lookupCTree :: Int -> CTree a -> Int -> a
-- O(?) where n is ? 

lookupCTree size (CLeaf x)     0 = x
lookupCTree size (CNode l x r) 0 = x
lookupCTree size (CNode l x r) i | i<=div size 2 = lookupCTree (div size 2) l (i-1)
                                 | otherwise     = lookupCTree (div size 2) r (i-1-div size 2)

updateCTree :: Int -> CTree a -> Int -> a -> CTree a
-- O(?) where n is ?

updateCTree size (CLeaf x)     0 y = CLeaf y
updateCTree size (CNode l x r) 0 y = CNode l y r
updateCTree size (CNode l x r) i y | i<=div size 2 = CNode (updateCTree (div size 2) l (i-1) y) x r 
                                   | otherwise     = CNode l x (updateCTree (div size 2) r (i-1-div size 2) y) 

-- both a list and an array

type SizedTree a = (Int,CTree a)

type ListArray a = [SizedTree a]

lookupFA :: ListArray a -> Int -> a
-- O(?) where n is ?

lookupFA ((s,t):sts) i | i<s       = lookupCTree s t i
                       | otherwise = lookupFA sts (i-s)

updateFA :: ListArray a -> Int -> a -> ListArray a
-- O(?) where n is ?

updateFA ((s,t):sts) i y | i<s       = (s,updateCTree s t i y):sts
                         | otherwise = (s,t):updateFA sts (i-s) y

emptyFA :: ListArray a
-- O(1)
emptyFA = [] 

isEmptyFA :: ListArray a -> Bool
-- O(1)
isEmptyFA = null 

consFA :: a -> ListArray a -> ListArray a
-- O(?) where n = ?

consFA x ((s1,t1):(s2,t2):ts) | s1==s2 = (1+s1+s2,CNode t1 x t2):ts
consFA x ts                            = (1,CLeaf x):ts

headFA :: ListArray a -> a
-- O(?) where n = ?

headFA ((1,CLeaf x)    :ts) = x
headFA ((s,CNode l x r):ts) = x

tailFA :: ListArray a -> ListArray a
-- O(?) where n = ?

tailFA ((1,CLeaf x)    :ts) = ts
tailFA ((s,CNode l x r):ts) = (div s 2,l):(div s 2,r):ts
```
