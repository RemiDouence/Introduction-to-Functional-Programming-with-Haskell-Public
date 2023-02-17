# Lab4
```
-- This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License
-- https://creativecommons.org/licenses/by-nc-nd/4.0/
-- Remi Douence

-- Please do not distribute solutions but let people learn by doing the exercices.
```
## Key Points
- QuickCheck generates random test from types 
- random numbers = a sequence of integers with a long period and a fair distribution
- stateful computation
- overloading return type with class and instances
## Module Import
- QuickCheck is quite rich we see only the tip of the iceberg
```
import Test.QuickCheck
import Data.Char
```
- QuickCheck is not part of the standard library 
```
-- to install quickcheck
-- myos> cabal update
-- myos> cabal install --lib QuickCheck
```
## QuickCheck example 
- a property is a predicate
```
appendProp1 :: ([Bool],[Bool]) -> Bool
appendProp1 (xs,ys) = length (xs++ys) == length xs + length ys
```
- quicheck randomly generate values to check a predicates
```
test = quickCheck appendProp1
```
- the verbose version shows the generated values
    - starting with the simplest/shortest values (counter examples)
```
testV = verboseCheck appendProp1
```
## Our Very Own QuickCheck
- we are going to rebuild our own (simple) version of quickcheck
### Random Numbers 
- http://fr.wikipedia.org/wiki/Générateur_de_nombres_aléatoires
-  http://fr.wikipedia.org/wiki/Générateur_de_nombres_pseudo-aléatoires
- a sequence of integers with a long period and a fair distribution
```
u :: Int -> Int
u n = (16807 * n) `mod` (2^31-1)
```
- all of them 
```
type Random = [Int]

random :: Random
random = drop 2 (iterate u 1)

test1 = take 10 random
```
- we could pass `n` around, but since Haskell is lazy we simply pass the (potenitaly) infinite list
### Generator 
- a generator of random values
    - uses (the begining of) a list of integers
    - returns the rest of the list that has not yet been used
```
type Generator a = Random -> (a,Random)
```
- to generate one `Bool` uses one `Int`
```
rBool :: Generator Bool
rBool (i:is) = (even i,is)
```
- to generate three `Bool` uses three `Int`
- define `r3Bools` with a `let`
```
r3Bools :: Generator (Bool,Bool,Bool)
r3Bools random = 
    let (b1,random1) = rBool random
        (b2,random2) = rBool random1
        (b3,random3) = rBool random2
    in ((b1,b2,b3),random3)

test2 = fst (r3Bools random)
```
- generate a list of booleans
    - stop or more?
    - if more generate the head and recursively the tail 
```
rListBool :: Generator [Bool]
rListBool random = 
    let (isNil,random1) = rBool random -- one Int is used to decide if the list is empty or not
    in if isNil 
       then ([],random1)
       else let (head,random2) = rBool     random1 -- if not empty, the another Int is used to generate the head of the list
                (tail,random3) = rListBool random2 -- and so on
            in (head:tail,random3)

test3 = fst (rListBool random)
```
- `length == 1` (50%)
- `length == 2` (25%)
- `length == 3` (12%)
- `length == 4` (6%)
- generate more cons than nil to get longer lists
```
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
```
- generate other type of elements
- the generator of element is an argument 
```
rList :: Generator a -> Generator [a]
rList genElt gen = 
    let (isNil,gen1) = rPercent gen 
    in if (isNil<20) 
       then ([],gen1)
       else let (head,gen2) = genElt       gen1 -- generate one element
                (tail,gen3) = rList genElt gen2
            in (head:tail,gen3)

test3'' = fst (rList rBool random)
```
- random `Char`
```
rChar :: Generator Char
rChar (i:is) = (chr (ord 'a' + i `mod` 26),is)

test4 = fst (rList rChar random)
```
## Overloading
- in Java:
    - `int m1(int x);` OK
    - `int m2(boolean x);` OK
    - `void m3(boolean x);` forbidden in Java (source), but OK haskell
- overload the return type of the generator 
### A micro QuickCheck
- reminder: `type Generator a = Random -> (a,Random)`
- each generator has a different **return** type
- we use a class type to overload myGenerate
```
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
```
- type base selection
- simply change the type to get more (or less) complex values
- the same definition, only the types are different
```
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
```
#### Generate enough test 
- a random list of value have a random length
- generate (lazily) infinite list of tests
```
infiniteGenerator :: TestGenerator a => Generator [a]
infiniteGenerator random =
  let (head,random2) = myGenerate random
      (tail,random3) = myGenerate random2
  in (head:tail,random3)

myQuickCheck :: TestGenerator a => (a -> Bool) -> Bool
myQuickCheck prop = let (tests,_) = infiniteGenerator random
                    in all prop (take 100 tests)
```
- our initial property 
```
myTest :: Bool
myTest = myQuickCheck appendProp1
```
- quickCheck offers many more possibilities
    - how to generate a tree (and stop)
    - how to generate very complex values by filtering them
    - etc.
## Monad State
- a monad is an interface
```
-- M a
-- thenM   :: M a -> (a -> M b) -> M b -- associative
-- returnM :: a -> M a  -- left and right neural for returnM
```
- different implementation
    - state
    - parallelism
    - maybe
    - list
    - etc.
- monads enable to declare effects and (sometimes) compose them
### Monad Input Output
```
-- IO a = RealWorld -> (a,RealWorld)
main :: IO ()
main = do
  print "exterieur"
  print "bloc"
  print gen1
```
- effects are sequentially composed
- no ambiguous situation such as:
```
-- m1() { print "A" ; }
-- m2() { print "B" ; }
-- o.m(o1.m1(),o2.m2())
```
