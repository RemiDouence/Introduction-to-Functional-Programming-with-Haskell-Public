# Lab1
```
-- This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License 
-- https://creativecommons.org/licenses/by-nc-nd/4.0/
-- Remi Douence

-- Please do not distribute solutions but let people learn by doing the exercices.
```
## Key Points
- why does functionnal programming matter?
- environment
- type
- constant
- function
## What is a Function?
- fact 4 returns 24
- fact 4 returns 24
- fact 4 returns 24
- a function is predictible
- your computer is not
    - you open it; it works
    - you open it; it works
    - you open it; it crashes
    - because there is a memory of past computation (mutable variable)
- moreover functions have been studied for a loooooong time by mathematicians and functions have very nice propreties (e.g., composition, associativity, commutativity, idempotence, black-box, etc.)
### Functions in Software Engineering 
- a value that can be computed versus a value that must be stored
- for instance a Set of elements: the cardinal (number of elements can be (re)computed)
- non functional / imperative programming: the cardinal must be maintained (bugs)
## Incremental computing 
- championship: each teams meet all other teams
- t teams = m matchs
- +1 teams = +t matchs 
- matchs (t+1) = t + matchs t
- matchs 0 = 0
- matchs 1 = 0
- matchs 2 = 1
- matchs 3 = 3 (triangle)
- matchs 4 = 6 (square)
- what cases are necessary?
## Haskell
- we will use Haskell https://www.haskell.org
### Haskell Editor
- you must use an editor with an Haskell mode
    - the layout is not free
    - never indent with `tab`
- suffix `.hs` for Haskell Script
### Haskell Interpreter
- `ghci Lab1.hs` in a shell
- no error message = all definitions of `Lab1.hs` availble
- an error message = **no** definition of `Lab1.hs` available
- REPL = Read ; Eval ; Print ; Loop
    - `1 + 2` then `ENTER`
- edit the file ; save it ; reload it `:r` ; rince ; repeat
    - do not forge to save the file **before** reloading
### Module (Import)
- Haskell provides many predefined functions in the default prelude https://hackage.haskell.org/package/base-4.17.0.0/docs/Prelude.html
- libraries offer numerous functions
    - the standard distribution comes with many libraries https://downloads.haskell.org/ghc/latest/docs/libraries/index.html
    - more libraries are available https://hackage.haskell.org
- we will use very few libraries. Here is how to import one of them.
```
import Data.List
```
- this imports the functions `insert` and `sort` required at the end of this session
## Comments
```
-- single line comment 
{- multi lines comment 
{- nested comment -}
-}
```
## Identifier
- an identifier is a sequence of alphanumeric characters but it must start with an alphabetic letter: `c1` 
## Type 
- `Int` is the type for integers
- type identifiers start with a capital letter 
## Constant
- a constant identifier starts with a lower case 
- a constant has a type 
```
c1 :: Int 
```
- a constant has a value 
```
c1 = 1 
```
- a constant is a constant: you cannot change its value ! Ever !
- a constant can be defined with a expression
```
c2 :: Int
c2 = 2+1
```
- definitions can be introduced in any order (backward and forward references are allowed)
## Function 
- `+` is a function that takes two integers and returns their sum
- `+` is an infix function (it occurs between its arguments)
    - functions whose identifiers use symbols (instead of letter) are infix by default
- an infix function can be called as a prefix function with brackets
```
c3 :: Int
c3 = (+) 2 1 
```
- `+`is predefined function 
- `mySub` is a user defined function 
```
mySub :: Int -> Int -> Int
mySub    x       y      = x - y 
```
- in arithmetics brackets can sometimes be ommited
- `1 + (2 * 3)` is equal to `1 + 2 * 3`
- in arithmetics brackets are sometimes necessary
- `1 + (2 * 3)` is different from `1 + 2 * 3`
- arrow `->` is right associative
- `mySub` with **useless** brackets can be defined as `mySub'` 
```
mySub' :: Int -> (Int -> Int)
mySub'    x       y      = x - y 
```
both definitions `mySub` and `mySub'` are fully equivalent
- `mySub'` makes it explicit that when it is applied to only one argument it returns a function that wait for the second argument
- any function with two or more argument can be partially applied
```
myNeg :: Int -> Int
myNeg x = mySub 0 x 
```
- `myNeg` waits for a single argument
- this definition can be simplified (eta-reduced) as follows:
```
myNeg' :: Int -> Int
myNeg' = mySub 0 
```
- `myNeg'` is simply defined as the partial application of `mySub` to only one argument `0`
## Boolean
- the type `Bool` is predefined (more on this in Lab4)
- the value `True` and `False` are predefined. These are values, not type, yet thei start with a capital letter (more on this in Lab4)
```
b1 :: Bool
b1 = True
```
- Haskell offers predefined boolean functions and `Int` comparison
```
b2 :: Bool
b2 = (b1 && False) || not b1

b3 :: Bool
b3 = 1>2 

b4 :: Bool
b4 = 1==2

b5 :: Bool -- not equal
b5 = 1/=2
```
## List of Integers
- Haskell offers predefined list of `Int`
- the type `[Int]`
- the value `[]` (named "nil") is the empty list with no integer
- the constructor `:` (named "cons")
- the type of cons is `Int -> [Int] -> [Int]` (do not called it with anything else)
- a constructor does not compute anything but it builds a data structure. Think about lists of integers as a binary tree with `:` nodes, left branches are integers, rightmost branch is `[]`.
```
l1 :: [Int]
l1 = []

l2 :: [Int]
l2 = 11 : 12 : l1
```
- in order to make types explicit we redefined cons and nil
```
myCons :: Int -> [Int] -> [Int]
myCons = (:)

myNil :: [Int]
myNil = []
```
### List Comprehension
- list comprehension enables to quickly define constants
```
l5 :: [Int]
l5 = [1..10]

l6 :: [Int]
l6 = [1,3..10]

l7 :: [Int]
l7 = [10,8..3]
```
- when there is no second value the default step is `1`
- when there is a second value the default step is `second value - first value`. In `l7` the step is `-2` (`8-10`).
## Pattern Matching
- pattern matching names sub terms in arguments 
```
myHead :: [Int] -> Int
myHead (x:xs) = x
```
- most of the time, when I define a function `myFoo` this means the function `foo` is predefined
- `myHead` is a partial function (it should never be called with nil `[]`)
- the function `head` is predefined 
- when the name is not used in the right hand side of `=` you can use underscore `_` as an anonymous placeholder
```
myTail :: [Int] -> [Int]
myTail (_:xs) = xs
```
## Recursive Function
- a function can calls itself
- `myAppend` glues to list together 
```
myAppend :: [Int] -> [Int] -> [Int]
myAppend = undefined
```
- `myAppend` **DOES NOT GLUE** two lists together
- `myAppend` computes a third list whose elements are the ones of the first list followed by the ones of the second list
- `myAppend` does not modify its arguments (we are in Haskell, they are constant)
- Haskell functions do not modify its arguments (a constant is constant)
- recursive call on smaller argument (otherwise you program may not terminate)
- the predefined function append is named `++`
- pattern matching is quite nice but if you are not a nice person you can also use acessors and guarded equations:
```
myAppend' :: [Int] -> [Int] -> [Int]
myAppend' xs ys | not (null xs) = head xs : myAppend' (tail xs) ys
                | otherwise     = ys
```
- a guard between `|` and `=` is a `Bool`
- when the guard is `False` Haskell try the next equation (so the order of equations can be important)
- `otherwise` is a predefined constant with the value `True` (remember `default` in Java `switch-case`)
- we can change the order on the equations, but `otherwise` must be replaced with `null xs` (otherwise the first equation would be always valid, the second equation would be useless, and the fucntion would simply return its second arguments)
```
myAppend'' :: [Int] -> [Int] -> [Int]
myAppend'' xs ys | null xs       = ys
                 | not (null xs) = head xs : myAppend'' (tail xs) ys
```
- we can first name subexpressions, then use then
- `let x = exp in exp`
```
myAppend4 :: [Int] -> [Int] -> [Int]
myAppend4 (x:xs) ys = 
    let suite = myAppend4 xs ys 
    in x:suite
myAppend4 []     ys = ys
```
- `let in` can be used to
- break big expressions into pieces
- give meaningfull names to subexpression
- share computation
- if you prefer to forward references (use first, then name) you can use `where`
```
myAppend5 :: [Int] -> [Int] -> [Int]
myAppend5 (x:xs) ys = x:suite where suite = myAppend5 xs ys
myAppend5 []     ys = ys
```
- in the append functions the second argument `ys` is only passed around until it is returned at the end
- we can defined a local (nested) function with a single argument (this nested function has acess to `ys`)
```
myAppend6 :: [Int] -> [Int] -> [Int]
myAppend6 xs ys = myAppend6' xs 
    where myAppend6' :: [Int] -> [Int]
          myAppend6' (x:xs) = x:myAppend6' xs
          myAppend6' []     = ys
```
## TODO
- in order to define `myInit`
    - call the predefined function `init` to understand what it does
    - complete the definition of `myInit`
    - test `myInit` is equivalent to `init`
```
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
```
