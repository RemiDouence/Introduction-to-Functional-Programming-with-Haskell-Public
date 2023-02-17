
-- This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
-- https://creativecommons.org/licenses/by-nc-nd/4.0/
-- Remi Douence

-- Please do not distribute solutions but let people learn by doing the exercices.

import Test.QuickCheck
import Data.Char

-- to install quickcheck
-- myos> cabal update
-- myos> cabal install --lib QuickCheck

appendProp1 :: ([Bool],[Bool]) -> Bool
appendProp1 (xs,ys) = length (xs++ys) == length xs + length ys

test = quickCheck appendProp1

testV = verboseCheck appendProp1

u :: Int -> Int
u n = (16807 * n) `mod` (2^31-1)

type Random = [Int]

random :: Random
random = drop 2 (iterate u 1)

test1 = take 10 random

type Generator a = Random -> (a,Random)

rBool :: Generator Bool
rBool (i:is) = (even i,is)

r3Bools :: Generator (Bool,Bool,Bool)
r3Bools random = 
    let (b1,random1) = rBool random
        (b2,random2) = rBool random1
        (b3,random3) = rBool random2
    in ((b1,b2,b3),random3)

test2 = fst (r3Bools random)

rListBool :: Generator [Bool]
rListBool random = 
    let (isNil,random1) = rBool random -- one Int is used to decide if the list is empty or not
    in if isNil 
       then ([],random1)
       else let (head,random2) = rBool     random1 -- if not empty, the another Int is used to generate the head of the list
                (tail,random3) = rListBool random2 -- and so on
            in (head:tail,random3)

test3 = fst (rListBool random)

rPercent :: Generator Int
rPercent (i:is) = (i `mod` 100,is)

rListBool' :: Generator [Bool]
rListBool' random = 
    let (isNil,random1) = rPercent random 
    in if (isNil<20) -- 20 percent
       then ([],random1)
       else let (head,random2) = rBool      random1
                (tail,random3) = rListBool' random2
            in (head:tail,random3)

test3' = fst (rListBool' random)

rList :: Generator a -> Generator [a]
rList genElt gen = 
    let (isNil,gen1) = rPercent gen 
    in if (isNil<20) 
       then ([],gen1)
       else let (head,gen2) = genElt       gen1 -- generate one element
                (tail,gen3) = rList genElt gen2
            in (head:tail,gen3)

test3'' = fst (rList rBool random)

rChar :: Generator Char
rChar (i:is) = (chr (ord 'a' + i `mod` 26),is)

test4 = fst (rList rChar random)

class TestGenerator a where
    myGenerate :: Generator a

instance TestGenerator Int where
    myGenerate (r:rs) = (r,rs)

instance TestGenerator Bool where
    myGenerate (r:rs) = (even r,rs)

instance TestGenerator Char where
    myGenerate (r:rs) = (chr (ord 'a' + r `mod` 26),rs)

instance TestGenerator a => TestGenerator [a] where
    myGenerate random = 
        let (isNil,random1) = rPercent random 
        in if (isNil<20)
           then ([],random1)
           else let (head,random2) = myGenerate random1 -- the type of head decice which myGenerate is called
                    (tail,random3) = myGenerate random2
                in (head:tail,random3)

-- yet another type
instance (TestGenerator a, TestGenerator b) => TestGenerator (a,b) where
    myGenerate random = 
        let (a,random1) = myGenerate random
            (b,random2) = myGenerate random1
        in ((a,b),random2)

gen1 :: [Int]
gen1 = fst (myGenerate random)

gen2 :: [Bool]
gen2 = fst (myGenerate random)

gen3 :: [[Bool]]
gen3 = fst (myGenerate random)

gen4 :: [(Int,[Bool])]
gen4 = fst (myGenerate random)

gen5 :: [(Int,[(Bool,String)])]
gen5 = fst (myGenerate random)

infiniteGenerator :: TestGenerator a => Generator [a]
infiniteGenerator random =
  let (head,random2) = myGenerate random
      (tail,random3) = myGenerate random2
  in (head:tail,random3)

myQuickCheck :: TestGenerator a => (a -> Bool) -> Bool
myQuickCheck prop = let (tests,_) = infiniteGenerator random
                    in all prop (take 100 tests)

myTest :: Bool
myTest = myQuickCheck appendProp1

-- M a
-- thenM   :: M a -> (a -> M b) -> M b -- associative
-- returnM :: a -> M a  -- left and right neural for returnM

-- IO a = RealWorld -> (a,RealWorld)
main :: IO ()
main = do
  print "exterieur"
  print "bloc"
  print gen1

-- m1() { print "A" ; }
-- m2() { print "B" ; }
-- o.m(o1.m1(),o2.m2())
