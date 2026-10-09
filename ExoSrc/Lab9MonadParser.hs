
{-# OPTIONS_GHC -Wno-x-partial #-} 

import Prelude hiding (foldr1,foldl1)
import Control.Applicative
import Control.Monad

-- arithmetic expression

data Exp 
  = Cte Int 
  | Add Exp Exp 
  | Mul Exp Exp 
  deriving (Show,Eq)

-- interpreter 

eval :: Exp -> Int 
eval (Cte i) = i 
eval (Add e1 e2) = eval e1 + eval e2 
eval (Mul e1 e2) = eval e1 * eval e2 

e1 = Add (Cte 1) (Mul (Cte 2) (Cte 3))

test1_eval = eval e1 == 7

e2 = Mul (Add (Cte 1) (Cte 2)) (Cte 3)

test2_eval = eval e2 == 9

-- printer 

showExp :: Exp -> String 
showExp (Cte i) = show i 
showExp (Add e1 e2) = bracket e1 ++ " + " ++ bracket e2
showExp (Mul e1 e2) = showExp e1 ++ " * " ++ showExp e2 

bracket :: Exp -> String
bracket (Mul e1 e2) = "(" ++ showExp (Mul e1 e2) ++ ")"
bracket e = showExp e 

test1_showExp = showExp e1 == "1 + (2 * 3)"

test2_showExp = showExp e2 == "1 + 2 * 3"

-- parser = state + list

data Parser a = Parser (String -> [(a,String)])

instance Functor Parser where 
  --fmap :: (a -> b) -> Parser a -> Parser b
  fmap f (Parser g) = Parser (\s0 -> [ (f a,s1) | (a,s1) <- g s0 ])

instance Applicative Parser where 
  --pure :: a -> Parser a 
  pure a = Parser (\s0 -> [(a,s0)])
  --(<*>) :: Parser (a -> b) -> Parser a -> Parser b 
  (Parser ff) <*> (Parser fa) = Parser (\s0 -> [ (f a,s2) | (f,s1) <- ff s0, (a,s2) <- fa s1 ])

instance Monad Parser where
  --return :: a -> Parser a 
  return = pure
  --(>>=) :: Parser a -> (a -> Parser b) -> Parser b 
  (Parser fa) >>= f = Parser (\s0 -> [ (b,s2) | (a,s1) <- fa s0, let Parser fb = f a, (b,s2) <- fb s1 ] )

runP :: Parser a -> String -> [(a,String)]
runP (Parser f) s = f s

charP :: Parser Char 
charP = 
  Parser (\s0 -> case s0 of -- exam: no case of
             c:cs -> [(c,cs)]
             ""   -> [])

test1_CharP = runP charP "abc" 

test2_charP = runP charP "" 

charCharP :: Parser (Char,Char)
charCharP = do
  c1 <- charP
  c2 <- charP
  return (c1,c2)
--charCharP = do { c1 <- charP; c2 <- charP; return (c1,c2) }
  
test1_charCharP = runP charCharP "abc" 

test2_charCharP = runP charCharP "a" 

instance Alternative Parser where 
  -- empty :: Parser a 
  empty = Parser (\s0 -> [])
  -- (<|>) :: Parser a -> Parser a -> Parser a 
  (Parser f1) <|> (Parser f2) = Parser (\s0 -> f1 s0 ++ f2 s0)

satP :: (a -> Bool) -> Parser a -> Parser a 
satP f p = do
  a <- p 
  if f a -- exam: no if then else
    then return a 
    else empty 

digitP :: Parser Char
digitP = satP (\c -> c >='0' && c <='9') charP

test1_digitP = runP digitP "123" 

test2_digitP = runP digitP "+23" 

someP :: Parser a -> Parser [a] -- one or more
someP p = 
  do a <- p
     as <- manyP p 
     return (a:as)
     
manyP :: Parser a -> Parser [a] -- none or more 
manyP p = 
  someP p 
  <|> 
  return []

test1_manyDigitP = runP (manyP digitP) "123+" 

test2_manyDigitP = runP (manyP digitP) "+123" 

-- TODO sequence of digits 

digitsP :: Parser String
digitsP = undefined

test1_digitsP = runP digitsP "123+45" == [("123","+45"),("12","3+45"),("1","23+45")]

test2_digitsP = runP digitsP "+45" == []

-- TODO the first result only

firstP :: Parser a -> Parser a 
firstP (Parser f) = undefined

intP :: Parser Int 
intP = do 
  cs <- firstP digitsP
  return (read cs)

test1_intP = runP intP "123+45" == [(123,"+45")]

-- TODO a constant string (e.g. keyword)

stringP :: String -> Parser ()
stringP = undefined

test1_stringP = runP (stringP "abc") "abcd" == [((),"d")]

test2_stringP = runP (stringP "abc") "abdc" == []

-- TODO the longest non empty sequence of pa separated by pb

sepbyP :: Parser a -> Parser b -> Parser [a]
pa `sepbyP` pb = firstP 
  (do a <- pa
      as <- manyP (do { pb ; pa })
      return (a:as)
   <|>
   undefined)

test1_sepby = runP (intP `sepbyP` stringP ",") "1,2,3,4+" == [([1,2,3,4],"+")]

test2_sepby = runP (intP `sepbyP` stringP ",") "11,22,33,+" == [([11,22,33],",+")]

--fold left non empty list

foldl1 :: (a -> a -> a) -> [a] -> a 
foldl1 f [a] = a 
foldl1 f as = f (foldl1 f (init as)) (last as)

test1_foldl1 = foldl1 Add (map Cte [1..4]) == Add (Add (Add (Cte 1) (Cte 2)) (Cte 3)) (Cte 4)

-- TODO sum of integers  

sumIntsP :: Parser Exp 
sumIntsP = undefined 

test1_sumIntsP = runP sumIntsP "1+23+456" == [(Add (Cte 1) (Add (Cte 23) (Cte 456)),"")]

--TODO arithmetic expression with addition, multiplication and brackets

sumP :: Parser Exp -- sum of products
sumP = undefined 

mulP :: Parser Exp -- product of terms
mulP = undefined 

termP :: Parser Exp -- an integer or a bracketed sum
termP = undefined 
  
test1_sumP = runP sumP "1" == [(Cte 1,"")]

test2_sumP = runP sumP "1+2" == [(Add (Cte 1) (Cte 2),"")]

test3_sumP = runP sumP "1*2*3" == [(Mul (Mul (Cte 1) (Cte 2)) (Cte 3),"")]

test4_sumP = runP sumP "1+2*3" == [(Add (Cte 1) (Mul (Cte 2) (Cte 3)),"")]

test5_sumP = runP sumP "(1+2)*3" == [(Mul (Add (Cte 1) (Cte 2)) (Cte 3),"")]

--TODO replace sumP, mulP and termP by a single function (take a list of operators in argument)

operators :: [(Parser (),Exp -> Exp -> Exp)]
operators = [(stringP "+",Add),(stringP "*",Mul)]

expP :: [(Parser (),Exp -> Exp -> Exp)] -> Parser Exp 
expP = undefined

test1_expP = runP (expP operators) "1" == [(Cte 1,"")]

test2_expP = runP (expP operators) "1+2" == [(Add (Cte 1) (Cte 2),"")]

test3_expP = runP (expP operators) "1*2*3" == [(Mul (Mul (Cte 1) (Cte 2)) (Cte 3),"")]

test4_expP = runP (expP operators) "1+2*3" == [(Add (Cte 1) (Mul (Cte 2) (Cte 3)),"")]

test5_expP = runP (expP operators) "(1+2)*3" == [(Mul (Add (Cte 1) (Cte 2)) (Cte 3),"")]

-- TODO finish or redo Lab1-8