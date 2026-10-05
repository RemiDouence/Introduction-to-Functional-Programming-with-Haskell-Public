-- This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License 
-- https://creativecommons.org/licenses/by-nc-nd/4.0/
-- Remi Douence

-- Please do not distribute solutions but let people learn by doing the exercices.

import Prelude hiding (map,mapM,mapM_)
import Data.IORef -- IORef, newIORef, writeIORef, readIORef
import Data.STRef -- STRef, newSTRef, writeSTRef, readSTRef
import Control.Monad.ST -- runST
import Data.Array.IO -- :set -package array
import Data.Array -- immutable array
import Control.Monad hiding (mapM,mapM_,forM,forM_) -- guard

-- objectives 
-- - IO monad 
-- - "do" notation
-- - ST monad 
-- - mutable variable Ref 
-- - mutable array 
-- - translate java code to monad IO
-- - imutable array

map :: (a -> b) -> [a] -> [b]
map f [] = []
map f (x:xs) = f x:map f xs

-- https://hackage.haskell.org/package/base-4.21.0.0/docs/Control-Monad.html#t:Monad
-- one type: 
-- IO a
-- two monad functions:
-- return :: a -> IO a 
-- >>= :: IO a -> (a -> IO b) -> IO b 

-- "impure" map

mapIO' :: (a -> IO b) -> [a] -> IO [b]
mapIO' f [] = return []
mapIO' f (x:xs) = 
  f x >>= (\y -> mapIO' f xs >>= (\ys -> return (y:ys)))

-- print :: Show a => a -> IO ()

mapIO_test1' = -- print then double 
  mapIO (\x -> print x >>= \y -> return (2*x)) [1..5]

-- 3 lines layout

mapIO'' :: (a -> IO b) -> [a] -> IO [b]
mapIO'' f [] = return []
mapIO'' f (x:xs) = 
  f x               >>= (\y -> 
  mapIO'' f xs      >>= (\ys -> 
  return (y:ys)))

-- "do" monadic syntax

mapIO :: (a -> IO b) -> [a] -> IO [b]
mapIO f [] = return []
mapIO f (x:xs) = do 
  y <- f x 
  ys <- mapIO f xs
  return (y:ys)

-- generic code for any monad

mapM :: (Monad m) => (a -> m b) -> [a] -> m [b]
mapM f [] = return []
mapM f (x:xs) = do 
  y <- f x 
  ys <- mapM f xs
  return (y:ys)

-- void-like type: unit (a single "value")
-- data () = () 

mapM_' :: (Monad m) => (a -> m ()) -> [a] -> m ()
mapM_' f [] = return ()
mapM_' f (x:xs) = do 
  -- () <- f x
  -- _ <- f x 
  f x 
  mapM_' f xs

-- less efficient because build the return value
mapM_ f xs = do
  mapM f xs 
  return ()

--TODO
-- [REC] forM'

forM' :: (Monad m) => [a] -> (a -> m b) -> m [b]
forM' = undefined 

--TODO
-- [NOREC] forM

forM :: (Monad m) => [a] -> (a -> m b) -> m [b]
forM = undefined 

--TODO
-- [NOREC]

forM_ :: (Monad m) => [a] -> (a -> m ()) -> m ()
forM_ = undefined 

-- purely functional fib 

-- [REC] O(1.6^n)

--  static int fib1(int n) {
--    if (n==0) return 0;
--    if (n==1) return 1;
--    else {
--      return fib1(n-1) + fib1(n-2);
--    }
--  }

fib1 :: Int -> Int 
fib1 0 = 0
fib1 1 = 1 
fib1 n = fib1 (n-1) + fib1 (n-2)

fib1_test1 = fib1 31 == 1346269
fib1_test2 = fib1 31 + fib1 10 == 1346324

-- imperative programming (python, java, C)
-- mutable variables:
-- newIORef :: a -> IO (IORef a) 
-- readIORef :: IORef a -> IO a 
-- writeIORef :: IORef a -> a -> IO ()

-- static int fib2(int n) {
--   int x = 0;
--   int y = 1;
--   for (int i=0; i<n; i++) {
--     int tmp = x;
--     x = y;
--     y = y+tmp;
--   }
--   return x;
-- }

--TODO
-- [REC] 

fibIORef :: Int -> IORef Int -> IORef Int -> IO () 
fibIORef n x y = undefined 

fib2 :: Int -> IO Int 
fib2 n = do 
  x <- newIORef 0
  y <- newIORef 1
  fibIORef n x y 
  readIORef x

fib2_test1 = do 
  n <- fib2 31 
  return (n == 1346269)
fib2_test2 = do 
  n <- fib2 31
  m <- fib2 10 
  return (n + m == 1346324)

-- mutable variable in a local state thread (run an imperative program locally)
-- newSTRef :: a -> ST s (STRef s a)
-- readSTRef :: STRef s a -> ST s a
-- writeSTRef :: STRef s a -> a -> ST s ()
-- runST :: (forall s. ST s a) -> a

-- fib ST
  
--TODO
-- [NOREC] use forM_
  
fibST :: Int -> ST s Int
fibST 0 = return 0
fibST 1 = return 1
fibST n = do
  var2 <- newSTRef 0
  var1 <- newSTRef 1
  forM_ [2 .. n] 
    undefined -- TODO
  readSTRef var1

fib3 :: Int -> Int 
fib3 n = runST (fibST n)

fib3_test1 = fib3 31 == 1346269
fib3_test2 = fib3 31 + fib3 10 == 1346324

-- compute an array of results 

-- static int[] fib4A;
-- static int fib4(int n) {
--   fib4A = new int[n+1];
--   fib4A[0] = 0;
--   fib4A[1] = 1;
--   for (int i=2; i<n+1; i++) {
--     fib4A[i] = fib4A[i-1]+ fib4A[i-2];
--   }
--   return fib4A[n];
-- }

-- mutable (IO) array
-- type: IOArray Int Int
-- newArray :: (MArray a e m, Ix i) => (i, i) -> e -> m (a i e)
-- writeArray :: (MArray a e m, Ix i) => a i e -> i -> e -> m ()
-- readArray :: (MArray a e m, Ix i) => a i e -> i -> m e

--TODO
-- fill the array

fib4 :: Int -> IO Int
fib4 0 = return 0
fib4 1 = return 1
fib4 n = do
  fs::IOArray Int Int <- newArray (0,n) 0
  writeArray fs 1 1
  forM [2 .. n] (\i -> 
    (do val2 <- readArray fs (i-2)
        val1 <- readArray fs (i-1)
        writeArray fs i (val1+val2)))
  readArray fs n

fib4_test1 = do 
  v <- fib4 31
  return (v == 1346269)

--TODO
-- memo function: fill the array as the computation progress
     
fib5 :: IOArray Int Int -> Int -> IO Int
fib5 m 0 = return 0
fib5 m 1 = return 1
fib5 m n = undefined

fib5_test1 = do 
  m <- newArray (0,100) 0
  f31 <- fib5 m 31
  f10 <- fib5 m 10
  return (f31 + f10 == 1346324)

-- nb: purely functional O(n) (in general this is not always possible)

fib6 :: Int -> Int 
fib6 0 = 0
fib6 1 = 1 
fib6 n = fib6' n 0 1 
  where fib6' :: Int -> Int -> Int -> Int
        fib6' 0 v2 v1 = v2
        fib6' n v2 v1 = fib6' (n-1) v1 (v1+v2)
        
fib6_test1 = fib6 31 == 1346269

-- quicksort in a mutable array

-- static int split(int[] xs,int i, int j) {
--   int p = i;
--   for (int l=i+1; l<=j; l++) {
--     if (xs[l]<=xs[p]) {
--       int tmp = xs[l];
--       if (p+1==l) {
--         xs[l] = xs[p];
--       } else {
--         xs[l] = xs[p+1];
--         xs[p+1] = xs[p];
--       }
--       xs[p] = tmp;
--       p++;
--     }
--   }
--   return p;
-- }

--TODO
-- [NOREC] forM
splitV1 :: IOArray Int Int -> Int -> Int -> IO Int 
splitV1 a i j = undefined

-- an alternative version of split with rec instead of forM and swap

swap2 :: IOArray Int Int -> Int -> Int -> IO ()
swap2 a i j = do 
  x <- readArray a i 
  y <- readArray a j
  writeArray a i y 
  writeArray a j x

swap3 :: IOArray Int Int -> Int -> Int -> Int -> IO ()
swap3 a i j k = do 
  x <- readArray a i 
  y <- readArray a j
  z <- readArray a k
  writeArray a i y 
  writeArray a j z
  writeArray a k x
  
splitV2 :: IOArray Int Int -> Int -> Int -> IO Int 
splitV2 a i j = splitV2' a i (i+1) j

--TODO
-- [REC]
splitV2' a p i j | i > j = return p
splitV2' a p i j = undefined

-- static void quickSort2(int[] xs, int i, int j) {
--   if (j>i) {
--     int k = split(xs,i,j);
--     quickSort2(xs,i,k-1);
--     quickSort2(xs,k+1,j);
--   }
-- }

quickSort2 :: IOArray Int Int -> Int -> Int -> IO () 
quickSort2 a i j 
  | i<j = do 
    k <- splitV1 a i j 
    --k <- splitV2 a i j
    quickSort2 a i (k-1)
    quickSort2 a (k+1) j                
  | otherwise = return ()

-- static void quickSort(int[] xs) {
--   quickSort2(xs,0,xs.length-1);
-- }

quickSort :: IOArray Int Int -> IO ()
quickSort a = do 
  (l,h) <- getBounds a 
  quickSort2 a l h

isSorted :: Ord a => [a] -> Bool
isSorted (x:y:xs) = x<=y && isSorted (y:xs)
isSorted _ = True 

quickSort_test1 = do 
  let xs :: [Int] = [0..9]
  a <- newListArray (0,length xs-1) xs 
  quickSort a 
  ys <- getElems a
  guard (isSorted ys)
  let xs :: [Int] = [9,8..0]
  a <- newListArray (0,length xs-1) xs 
  quickSort a 
  ys <- getElems a
  guard (isSorted ys)
  let xs :: [Int] = [5,7,2,0,1,3,9,8,5,6]
  a <- newListArray (0,length xs-1) xs 
  quickSort a 
  ys <- getElems a
  return (isSorted ys)

-- linked list

-- class Cell<A> {
--   final A data;
--   Cell<A> next;
--   Cell(A data, Cell<A> next) {
--     this.data = data;
--     this.next = next;
--   }
--   A getData() {
--     return this.data;
--   }
--   Cell<A> getNext() {
--     return this.next;
--   }
--   void setNext(Cell<A> next) {
--     this.next = next;
--   }
--   public String toString() {
--     String result = "" + this.getData();
--     if (this.getNext() != null) {
--       result += " " + this.getNext().toString();
--     }
--     return result;
--   }
-- }

data Cell a = Cell a (IORef (Maybe (Cell a)))

--TODO
cellNew :: a -> Maybe (Cell a) -> IO (Cell a)
cellNew a next = undefined 

--TODO
cellGetA :: Cell a -> a 
cellGetA = undefined 

--TODO
cellGetNext :: Cell a -> IO (Maybe (Cell a))
cellGetNext = undefined 

--TODO
cellSetNext :: Cell a -> Maybe (Cell a) -> IO ()
cellSetNext = undefined 

cellToString :: Show a => Cell a -> IO String
cellToString c = do 
  cmb <- cellGetNext c 
  case cmb of 
    Nothing -> return (show (cellGetA c))
    Just c' -> do s <- cellToString c'
                  return (show (cellGetA c) ++ " " ++ s)

-- class LinkedList<A> {
--   Cell<A> head;

type LinkedList a = IORef (Maybe (Cell a))

--TODO
linkedListNew :: IO (LinkedList a)
linkedListNew = newIORef Nothing

--   public String toString() {
--     if (this.head != null) {
--       return this.head.toString();
--     } else {
--       return "";
--     }
--   }

--TODO
linkedListToString :: Show a => LinkedList a -> IO String
linkedListToString l = do 
  mbc <- readIORef l 
  case mbc of 
    Nothing -> return "" 
    Just c -> cellToString c

--   void add(A data) { 
--     Cell<A> tmp = new Cell<A>(data,head);
--       head = tmp;
--   }

--TODO
linkedListAdd :: LinkedList a -> a -> IO ()
linkedListAdd l a = undefined 

--   void remove() {
--     head = head.next;
--   }

--TODO
linkedListRemove :: LinkedList a -> IO ()
linkedListRemove l = undefined 

--   void addLast(A data) { 
--     if (head==null) {
--       head = new Cell<A>(data,null);
--     } else {
--       Cell<A> tmp = head;
--       while (tmp.next != null) {
--         tmp = tmp.next;
--       }
--       tmp.next = new Cell<A>(data,null);
--     }
--   }
  
--TODO
getLast :: Cell a -> IO (Cell a) 
getLast c = undefined 

--TODO
linkedListAddLast :: LinkedList a -> a -> IO ()  
linkedListAddLast l a = undefined
    
--   void removeLast() { 
--     Cell<A> tmp1 = head;
--     Cell<A> tmp2 = tmp1.next;
--     if (tmp2 == null) {
--       this.head = null;
--     } else {
--       while (tmp2.next != null) {
--         tmp1 = tmp2;
--         tmp2 = tmp2.next;
--       }
--       tmp1.next = null;
--     }
--   }

--TODO
linkedListRemoveLast :: LinkedList a -> IO () 
linkedListRemoveLast l = undefined 
    
--TODO
linkedListRemoveLast' :: Cell a -> IO () 
linkedListRemoveLast' c = undefined

linkedList_test1 = do 
  l <- linkedListNew 
  linkedListAdd l 1
  linkedListAdd l 2
  linkedListAddLast l 3
  s <- linkedListToString l
  guard (s == "2 1 3")
  putStrLn s
  linkedListRemove l
  s <- linkedListToString l
  guard (s == "1 3")
  putStrLn s
  linkedListRemoveLast l
  s <- linkedListToString l
  guard (s == "1")
  putStrLn s


-- immutable arrays

-- List of pairs index value (in any order)
-- each call to fib is independent (no computation sharing)

-- array :: Ix i => (i, i) -> [(i, e)] -> Array i e
fibA1 n = array (0,n) [ (i,fib1 i) | i <- [0 .. n] ]

testFibA1 = fibA1 100 ! 31 == 1346269

-- List of values in the index order
-- each call to fib1 is independent (no computation sharing)

-- listArray :: Ix i => (i, i) -> [e] -> Array i e
fibA2 n = listArray (0,n) [ fib1 i | i <- [0 .. n] ]

testFibA2 = fibA2 100 ! 31 == 1346269

-- List of values in the index order
-- recursive definition: each cell definition can be based on other cells 
-- beware of loops
-- laziness 

fibA2' n = -- recursive (lazy) array :-)
  let a = listArray (0,n) (0:1:[ a ! (i-1) + a ! (i-2) | i <- [2 .. n] ])
  in a

testFibA2' = fibA2' 100 ! 31 == 1346269

-- List of pairs index value with possibly duplicated index 
-- accum array: a cell can be defined by the accumulation of several values 
-- this is not a very convincing example :-(

-- accumArray :: Ix i => (e -> a -> e) -> e -> (i, i) -> [(i, a)] -> Array i e
fibA3 n = accumArray (+) 0 (0,n) ([ (i,fib1 (i-1)) | i <- [1 .. n] ] ++ [ (i,fib1 (i-2)) | i <- [2 .. n] ])

testFibA3 = fibA3 20 ! 15 == 610


-- TODO: define rectangular matrix and their product
