
-- This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License 
-- https://creativecommons.org/licenses/by-nc-nd/4.0/
-- Remi Douence

-- Please do not distribute solutions but let people learn by doing the exercices.

{-# OPTIONS_GHC -Wno-x-partial #-} 

import Prelude hiding (not,and,or)

--infixr 3 `Seq`

-- primary objectives:
-- - boolean operators 
-- - quantifiers 
-- secondary objectives 
-- - nand is enough
-- - macro shallow embedding
-- - macro deep enmbedding
-- - abstract machine

-- PART 0) BOOLEAN OPERATORS

-- define boolean operators
-- - pattern matching only
-- - only two equations

not :: Bool -> Bool
not True = False
not _    = True

test1_not = not True  == False
test2_not = not False == True 
test_not = test1_not && test2_not

and :: Bool -> Bool -> Bool 
and = undefined

test1_and = and True  True  == True 
test2_and = and True  False == False
test3_and = and False True  == False 
test4_and = and False False == False
test_and = test1_and && test2_and && test3_and && test4_and

or :: Bool -> Bool -> Bool 
or = undefined 

test1_or = or True  True  == True 
test2_or = or True  False == True
test3_or = or False True  == True 
test4_or = or False False == False
test_or = test1_or && test2_or && test3_or && test4_or

xor :: Bool -> Bool -> Bool 
xor = undefined

test1_xor = xor True  True  == False 
test2_xor = xor True  False == True
test3_xor = xor False True  == True
test4_xor = xor False False == False
test_xor = test1_xor && test2_xor && test3_xor && test4_xor

nand :: Bool -> Bool -> Bool
nand = undefined 

test1_nand = nand True  True  == False 
test2_nand = nand True  False == True
test3_nand = nand False True  == True 
test4_nand = nand False False == True
test_nand = test1_nand && test2_nand && test3_nand && test4_nand

imply :: Bool -> Bool -> Bool 
imply = undefined

test1_imply = imply True  True  == True 
test2_imply = imply True  False == False
test3_imply = imply False True  == True 
test4_imply = imply False False == True
test_imply = test1_imply && test2_imply && test3_imply && test4_imply

-- PART 1) v1: boolean expression 

type Var = String

data B1
  = T1
  | F1
  | Not1 B1
  | Or1 B1 B1 
  | Xor1 B1 B1 
  | And1 B1 B1 
  | Nand1 B1 B1
  | Imply1 B1 B1
  | Forall1 Var B1
  | Exist1 Var B1
  | Var1 Var
  deriving (Show,Eq)

-- size (number of nodes/leaves in the tree)

size1 :: B1 -> Int 
size1 T1 = 1
size1 F1 = 1 
size1 (Not1 b) = 1 + size1 b
size1 (Or1 b1 b2) = 1 + size1 b1 + size1 b2 
size1 (Xor1 b1 b2) = 1 + size1 b1 + size1 b2 
size1 (And1 b1 b2) = 1 + size1 b1 + size1 b2 
size1 (Nand1 b1 b2) = 1 + size1 b1 + size1 b2
size1 (Imply1 b1 b2) = 1 + size1 b1 + size1 b2
size1 (Forall1 x b) = 1 + size1 b
size1 (Exist1 x b) = 1 + size1 b 
size1 (Var1 x) = 1

test1_size1 = size1 (Exist1 "x" (Forall1 "y" (Imply1 (Var1 "x") (Var1 "y")))) == 5

-- substitution

subst1 :: (Var,B1) -> B1 -> B1 
--subst1 (x,b) b2 replace x by b in b2
subst1 bind T1 = T1
subst1 bind F1 = F1
subst1 bind (Not1 b) = Not1 (subst1 bind b)
subst1 bind (Or1 b1 b2) = Or1 (subst1 bind b1) (subst1 bind b2)
subst1 bind (Xor1 b1 b2) = Xor1 (subst1 bind b1) (subst1 bind b2)
subst1 bind (And1 b1 b2) = And1 (subst1 bind b1) (subst1 bind b2)
subst1 bind (Nand1 b1 b2) = Nand1 (subst1 bind b1) (subst1 bind b2)
subst1 bind (Imply1 b1 b2) = Imply1 (subst1 bind b1) (subst1 bind b2)
subst1 (x',b') (Forall1 x b) 
  | x == x' = undefined
  | x /= x' = undefined
subst1 (x',b') (Exist1 x b)  
  | x == x' = undefined
  | x /= x' = undefined
subst1 (x',b') (Var1 x) 
  | x == x' = undefined
  | x /= x' = undefined

-- interpreter 

eval1 :: B1 -> Bool
eval1 T1 = True
eval1 F1 = False
eval1 (Not1 b) = not (eval1 b)
eval1 (Or1 b1 b2) = or (eval1 b1) (eval1 b2)
eval1 (Xor1 b1 b2) = xor (eval1 b1) (eval1 b2)
eval1 (And1 b1 b2) = and (eval1 b1) (eval1 b2)
eval1 (Nand1 b1 b2) = nand (eval1 b1) (eval1 b2)
eval1 (Imply1 b1 b2) = imply (eval1 b1) (eval1 b2)
eval1 (Forall1 x b) = undefined
eval1 (Exist1 x b) = undefined

test1_eval1 = eval1 (Exist1 "x" (Forall1 "y" (Imply1 (Var1 "x") (Var1 "y")))) == True
test2_eval1 = eval1 (Exist1 "x" (Forall1 "x" (Imply1 (Var1 "x") (Var1 "x")))) == True

-- PART 2) v2: subset expression + shallow macros

-- subset

data B2
  = T2
  | Nand2 B2 B2
  deriving (Show,Eq)

-- interpreter 

eval2 :: B2 -> Bool
eval2 = undefined 

-- (shallow embedding) macros

t2 :: B2
t2 = T2

test1_t2 = eval2 t2 == True

nand2 :: B2 -> B2 -> B2 
nand2 = undefined

test1_nand2 = eval2 (nand2 t2 t2) == False

not2 :: B2 -> B2 
not2 = undefined

test1_not2 = eval2 (not2 t2) == False

f2 :: B2
f2 = undefined

test1_f2 = eval2 f2 == False

and2 :: B2 -> B2 -> B2 
and2 = undefined

test1_and2 = eval2 (and2 t2 t2) == True
test2_and2 = eval2 (and2 t2 f2) == False
test3_and2 = eval2 (and2 f2 t2) == False
test4_and2 = eval2 (and2 f2 f2) == False
test_and2 = test1_and2 && test2_and2 && test3_and2 && test4_and2                    

or2 :: B2 -> B2 -> B2 
or2 = undefined

test1_or2 = eval2 (or2 t2 t2) == True
test2_or2 = eval2 (or2 t2 f2) == True
test3_or2 = eval2 (or2 f2 t2) == True
test4_or2 = eval2 (or2 f2 f2) == False
test_or2 = test1_or2 && test2_or2 && test3_or2 && test4_or2                    

xor2 :: B2 -> B2 -> B2 
xor2 = undefined

test1_xor2 = eval2 (xor2 t2 t2) == False
test2_xor2 = eval2 (xor2 t2 f2) == True
test3_xor2 = eval2 (xor2 f2 t2) == True
test4_xor2 = eval2 (xor2 f2 f2) == False
test_xor2 = test1_xor2 && test2_xor2 && test3_xor2 && test4_xor2

imply2 :: B2 -> B2 -> B2 
imply2 = undefined
  
test1_imply2 = eval2 (imply2 t2 t2) == True
test2_imply2 = eval2 (imply2 t2 f2) == False
test3_imply2 = eval2 (imply2 f2 t2) == True
test4_imply2 = eval2 (imply2 f2 f2) == True
test_imply2 = test1_imply2 && test2_imply2 && test3_imply2 && test4_imply2

forall2 :: (B2 -> B2) -> B2
forall2 = undefined

exist2 :: (B2 -> B2) -> B2
exist2 = undefined

test1_eval2 = eval2 (exist2 (\x -> (forall2 (\y -> (imply2 x y))))) == True

size2 :: B2 -> Int 
size2 T2 = 1
size2 (Nand2 b1 b2) = 1 + size2 b1 + size2 b2

test1_size2 = size2 (exist2 (\x -> (forall2 (\y -> (imply2 x y))))) == 9215

-- new operator (equivalence)

equiv2 :: B2 -> B2 -> B2 
equiv2 = undefined

test1_equiv2 = eval2 (equiv2 t2 t2) == True
test2_equiv2 = eval2 (equiv2 t2 f2) == False
test3_equiv2 = eval2 (equiv2 f2 t2) == False
test4_equiv2 = eval2 (equiv2 f2 f2) == True

-- PART 3) v3: subset expression + (deep embedding) macros

-- subset with explicit macro call

type Name = String 

data B3
  = T3
  | Nand3 B3 B3
  | Var3 Var
  | Call3 Name [B3] -- call a macro
  | Subst3 (Var,B3) B3 -- reify substitution for forall/exist
  deriving (Show,Eq)

type Macro3 = ([Var],B3) -- (arguments,body)

-- substitution 

subst3 :: (Var,B3) -> B3 -> B3 
--subst3 (x,b) b2 replace x by b in b2
subst3 bind T3 = T3
subst3 bind (Nand3 b1 b2) = Nand3 (subst3 bind b1) (subst3 bind b2)
subst3 (x',b) (Var3 x) 
  | x == x' = b
  | x /= x' = Var3 x
subst3 bind (Call3 m bs) = Call3 m (map (subst3 bind) bs) 
subst3 (x',Var3 y) (Subst3 (x,b1) b2) 
  | x == x' = undefined
  | x /= x' = undefined
subst3 (x',b) (Subst3 (x,b1) b2) = undefined

-- environment 

type Env a = [(Var,a)]
 
new :: (Var,a) -> Env a -> Env a 
new bind env = bind:env

get :: Var -> Env a -> a 
get x ((y,a):env)
  | x==y = a
  | otherwise = get x env

-- macro expansion (aka inlining) 

expand :: Env Macro3 -> B3 -> B3 
expand ms T3 = T3
expand ms (Nand3 b1 b2) = Nand3 (expand ms b1) (expand ms b2)
expand ms (Var3 x) = Var3 x
expand ms (Call3 m bs) = 
  let (xs,b) = undefined -- lookup definition
      bs2 = undefined -- expand arguments 
      b2 = undefined -- subst arguments
  in undefined -- expand body
expand ms (Subst3 (x,b1) b2) = subst3 (x,expand ms b1) (expand ms b2) 

-- interpreter (no Var3, Call3, Subst3 after expand)

eval3 :: B3 -> Bool 
eval3 T3 = True
eval3 (Nand3 b1 b2) = nand (eval3 b1) (eval3 b2)

operators3 :: Env Macro3
operators3 = 
  [ ("f",([],Nand3 T3 T3))
  , ("not",(["b"],Nand3 (Var3 "b") (Var3 "b")))
  , ("and",(["b1","b2"],Call3 "not" [Nand3 (Var3 "b1") (Var3 "b2")]))
  , ("or",(["b1","b2"],Call3 "not" [Call3 "and" [Call3 "not" [Var3 "b1"],Call3 "not" [Var3 "b2"]]]))
  , ("xor",(["b1","b2"],Call3 "or" [Call3 "and" [Var3 "b1",Call3 "not" [Var3 "b2"]]
                                   ,Call3 "and" [Call3 "not" [Var3 "b1"],Var3 "b2"]]))
  , ("imply",(["b1","b2"],Call3 "or" [Call3 "and" [Var3 "b1",Var3 "b2"],Call3 "not" [Var3 "b1"]]))
  , ("equiv",(["b1","b2"],Call3 "and" [Call3 "imply" [Var3 "b1",Var3 "b2"],Call3 "imply" [Var3 "b2",Var3 "b1"]]))
  , ("forall",(["x","b"],undefined))
  , ("exist",(["x","b"],undefined))
  ]
  
test_f3 = eval3 (expand operators3 (Call3 "f" [])) == False

test1_not3 = eval3 (expand operators3 (Call3 "not" [T3])) == False
test2_not3 = eval3 (expand operators3 (Call3 "not" [Call3 "f" []])) == True
test_not3 = test1_not3 && test2_not3

test1_and3 = eval3 (expand operators3 (Call3 "and" [T3,T3])) == True
test2_and3 = eval3 (expand operators3 (Call3 "and" [T3,Call3 "f" []])) == False
test3_and3 = eval3 (expand operators3 (Call3 "and" [Call3 "f" [],T3])) == False
test4_and3 = eval3 (expand operators3 (Call3 "and" [Call3 "f" [],Call3 "f" []])) == False
test_and3 = test1_and3 && test2_and3 && test3_and3 && test4_and3

test1_or3 = eval3 (expand operators3 (Call3 "or" [T3,T3])) == True
test2_or3 = eval3 (expand operators3 (Call3 "or" [T3,Call3 "f" []])) == True
test3_or3 = eval3 (expand operators3 (Call3 "or" [Call3 "f" [],T3])) == True
test4_or3 = eval3 (expand operators3 (Call3 "or" [Call3 "f" [],Call3 "f" []])) == False
test_or3 = test1_or3 && test2_or3 && test3_or3 && test4_or3

test1_xor3 = eval3 (expand operators3 (Call3 "xor" [T3,T3])) == False
test2_xor3 = eval3 (expand operators3 (Call3 "xor" [T3,Call3 "f" []])) == True
test3_xor3 = eval3 (expand operators3 (Call3 "xor" [Call3 "f" [],T3])) == True
test4_xor3 = eval3 (expand operators3 (Call3 "xor" [Call3 "f" [],Call3 "f" []])) == False
test_xor3 = test1_xor3 && test2_xor3 && test3_xor3 && test4_xor3

test1_imply3 = eval3 (expand operators3 (Call3 "imply" [T3,T3])) == True
test2_imply3 = eval3 (expand operators3 (Call3 "imply" [T3,Call3 "f" []])) == False
test3_imply3 = eval3 (expand operators3 (Call3 "imply" [Call3 "f" [],T3])) == True
test4_imply3 = eval3 (expand operators3 (Call3 "imply" [Call3 "f" [],Call3 "f" []])) == True
test_imply3 = test1_imply3 && test2_imply3 && test3_imply3 && test4_imply3

test1_eval3 = eval3 (expand operators3 (Call3 "exist" [Var3 "x",Call3 "forall" [Var3 "y",Call3 "imply" [Var3 "x",Var3 "y"]]])) == True

size3 :: B3 -> Int 
size3 T3 = 1
size3 (Nand3 b1 b2) = 1 + size3 b1 + size3 b2
size3 (Var3 x) = 1

test1_size3 = size3 (expand operators3 (Call3 "exist" [Var3 "x",Call3 "forall" [Var3 "y",Call3 "imply" [Var3 "x",Var3 "y"]]])) == 9215

test1_equiv3 = eval3 (expand operators3 (Call3 "equiv" [T3,T3])) == True
test2_equiv3 = eval3 (expand operators3 (Call3 "equiv" [T3,Call3 "f" []])) == False
test3_equiv3 = eval3 (expand operators3 (Call3 "equiv" [Call3 "f" [],T3])) == False
test4_equiv3 = eval3 (expand operators3 (Call3 "equiv" [Call3 "f" [],Call3 "f" []])) == True
test_equiv3 = test1_equiv3 && test2_equiv3 && test3_equiv3 && test4_equiv3

-- PART 4) lazy substitution (aka environment) and functions 

data B4
  = T4
  | Nand4 B4 B4
  | Var4 Var
  | Call4 Name [B4]
  | Forall4 Var B4
  | Exist4 Var B4
  deriving (Show,Eq)

type Macro4 = ([Var],B4)

-- interpreter 
 
eval4 :: Env Macro4 -> Env Bool -> B4 -> Bool 
eval4 envM envV T4 = True
eval4 envM envV (Nand4 b1 b2) = nand (eval4 envM envV b1) (eval4 envM envV b2)
eval4 envM envV (Call4 m args) = 
  let (xs,body) = undefined -- lookup definition
      bools = undefined -- eval arguments (cbv)
      envV2 = undefined -- extend environment (delay substitution) 
  in undefined -- eval body
eval4 envM envV (Var4 x) = undefined -- access delayed substitution
eval4 envM envV (Forall4 x b) = eval4 envM ((x,True):envV) b && eval4 envM ((x,False):envV) b
eval4 envM envV (Exist4 x b) = eval4 envM ((x,True):envV) b || eval4 envM ((x,False):envV) b

operators4 :: Env Macro4
operators4 = 
  [ ("f",([],Nand4 T4 T4))
  , ("not",(["b"],Nand4 (Var4 "b") (Var4 "b")))
  , ("and",(["b1","b2"],Call4 "not" [Nand4 (Var4 "b1") (Var4 "b2")]))
  , ("or",(["b1","b2"],Call4 "not" [Call4 "and" [Call4 "not" [Var4 "b1"],Call4 "not" [Var4 "b2"]]]))
  , ("xor",(["b1","b2"],Call4 "or" [Call4 "and" [Var4 "b1",Call4 "not" [Var4 "b2"]]
                                   ,Call4 "and" [Call4 "not" [Var4 "b1"],Var4 "b2"]]))
  , ("imply",(["b1","b2"],Call4 "or" [Call4 "and" [Var4 "b1",Var4 "b2"],Call4 "not" [Var4 "b1"]]))
  , ("equiv",(["b1","b2"],Call4 "and" [Call4 "imply" [Var4 "b1",Var4 "b2"],Call4 "imply" [Var4 "b2",Var4 "b1"]]))
  ]

test_f4 = eval4 operators4 [] (Call4 "f" []) == False

test1_not4 = eval4 operators4 [] (Call4 "not" [T4]) == False
test2_not4 = eval4 operators4 [] (Call4 "not" [Call4 "f" []]) == True
test_not4 = test1_not4 && test2_not4

test1_and4 = eval4 operators4 [] (Call4 "and" [T4,T4]) == True
test2_and4 = eval4 operators4 [] (Call4 "and" [T4,Call4 "f" []]) == False
test3_and4 = eval4 operators4 [] (Call4 "and" [Call4 "f" [],T4]) == False
test4_and4 = eval4 operators4 [] (Call4 "and" [Call4 "f" [],Call4 "f" []]) == False
test_and4 = test1_and4 && test2_and4 && test3_and4 && test4_and4

test1_or4 = eval4 operators4 [] (Call4 "or" [T4,T4]) == True
test2_or4 = eval4 operators4 [] (Call4 "or" [T4,Call4 "f" []]) == True
test3_or4 = eval4 operators4 [] (Call4 "or" [Call4 "f" [],T4]) == True
test4_or4 = eval4 operators4 [] (Call4 "or" [Call4 "f" [],Call4 "f" []]) == False
test_or4 = test1_or4 && test2_or4 && test3_or4 && test4_or4

test1_xor4 = eval4 operators4 [] (Call4 "xor" [T4,T4]) == False
test2_xor4 = eval4 operators4 [] (Call4 "xor" [T4,Call4 "f" []]) == True
test3_xor4 = eval4 operators4 [] (Call4 "xor" [Call4 "f" [],T4]) == True
test4_xor4 = eval4 operators4 [] (Call4 "xor" [Call4 "f" [],Call4 "f" []]) == False
test_xor4 = test1_xor4 && test2_xor4 && test3_xor4 && test4_xor4

test1_imply4 = eval4 operators4 [] (Call4 "imply" [T4,T4]) == True
test2_imply4 = eval4 operators4 [] (Call4 "imply" [T4,Call4 "f" []]) == False
test3_imply4 = eval4 operators4 [] (Call4 "imply" [Call4 "f" [],T4]) == True
test4_imply4 = eval4 operators4 [] (Call4 "imply" [Call4 "f" [],Call4 "f" []]) == True
test_imply4 = test1_imply4 && test2_imply4 && test3_imply4 && test4_imply4

test1_exist4 = eval4 operators4 [] (Exist4 "x" (Forall4 "y" (Call4 "imply" [Var4 "x",Var4 "y"]))) == True

size4 :: B4 -> Int 
size4 T4 = 1
size4 (Nand4 b1 b2) = 1 + size4 b1 + size4 b2
size4 (Var4 x) = 1
size4 (Call4 m bs) = 1 + sum (map size4 bs)

test1_size4 
  = sum [ size4 body | (m,(xs,body)) <- operators4 ] 
    + size4 (Call4 "exist" [Var4 "x",Call4 "forall" [Var4 "y",Call4 "imply" [Var4 "x",Var4 "y"]]])
    == 59

test1_equiv4 = eval4 operators4 [] (Call4 "equiv" [T4,T4]) == True
test2_equiv4 = eval4 operators4 [] (Call4 "equiv" [T4,Call4 "f" []]) == False
test3_equiv4 = eval4 operators4 [] (Call4 "equiv" [Call4 "f" [],T4]) == False
test4_equiv4 = eval4 operators4 [] (Call4 "equiv" [Call4 "f" [],Call4 "f" []]) == True
test_equiv4 = test1_equiv4 && test2_equiv4 && test3_equiv4 && test4_equiv4

-- PART 5) V4: compilation from B2 to an abstract (stack) machine

data I -- instruction
  = IPush -- push true 
  | INand -- pop; pop; push nand 
  deriving (Show,Eq)

run :: ([I],[Bool]) -> Bool 
run ([],        [b])      = b
run (IPush:is,  bs)       = run (is, True:bs)
run (INand:is,  b1:b2:bs) = run (is, nand b1 b2:bs)

compile :: B2 -> [I]
compile = undefined

exec :: B2 -> Bool
exec b = run (compile b,[])

test1_exec = exec (exist2 (\x -> forall2 (\y -> imply2 x y))) == True
