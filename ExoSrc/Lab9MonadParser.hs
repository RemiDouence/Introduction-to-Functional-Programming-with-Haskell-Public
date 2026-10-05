
{-# OPTIONS_GHC -Wno-x-partial #-} 

import Prelude hiding (Maybe,Just,Nothing,IO)
import Control.Applicative
import Control.Monad

-- arithmetic expression

data Exp 
  = Cte Int 
  | Add Exp Exp 
  | Div Exp Exp 
  deriving (Show,Eq)

-- standard interpreter 

eval :: Exp -> Int 
eval (Cte i) = i 
eval (Add e1 e2) = eval e1 + eval e2 
eval (Div e1 e2) = eval e1 `div` eval e2 

e1 = Div (Add (Cte 3) (Cte 3)) (Add (Cte 6) (Cte 4))

test_eval1 = eval e1 == 0

e2 = Div (Add (Cte 3) (Cte 3)) (Add (Cte 4) (Cte (-4)))

test_eval2 = eval e2 -- error

-- error EXPLICIT propagation

data Maybe a = Just a | Nothing deriving (Show,Eq)

evalMayBe :: Exp -> Maybe Int 
evalMayBe (Cte i) = Just i 
evalMayBe (Add e1 e2) = 
  case evalMayBe e1 of -- never use case (never use if) !!!
    Nothing -> Nothing 
    Just i1 -> case evalMayBe e2 of
      Nothing -> Nothing  
      Just i2 -> Just (i1+i2)
evalMayBe (Div e1 e2) = 
  case (evalMayBe e1,evalMayBe e2) of 
    (Just i1,Just 0)  -> Nothing
    (Just i1,Just i2) -> Just (i1 `div` i2)
    _                 -> Nothing 

test_eval1' = evalMayBe e1 == Just 0

test_eval2' = evalMayBe e2 == Nothing

-- error IMPLICIT propagation (monad Maybe)

returnMB :: a -> Maybe a 
returnMB x = Just x 

thenMB :: Maybe a -> (a -> Maybe b) -> Maybe b
thenMB (Just x) f = f x 
thenMB Nothing  f = Nothing 

evalMB :: Exp -> Maybe Int 
evalMB (Cte i) = returnMB i 
evalMB (Add e1 e2) = 
  (evalMB e1) `thenMB` (\n1 -> (evalMB e2) `thenMB` (\n2 -> returnMB (n1+n2)))
evalMB (Div e1 e2) = 
  (evalMB e1) `thenMB` (\n1 -> 
  (evalMB e2) `thenMB` (\n2 -> 
  if (n2 == 0) then Nothing else returnMB (n1 `div` n2))) -- div by 0

test_eval1'' = evalMB e1 == Just 0

test_eval2'' = evalMB e2 == Nothing

-- return + then = "design pattern" 
-- class Monad = return + (>>=) + do-notation

-- class Functor f where 
--   fmap :: (a -> b) -> f a -> f b 

instance Functor Maybe where
  -- fmap :: (a -> b) -> Maybe a -> Maybe b
  fmap f (Just x) = Just (f x)
  fmap f Nothing = Nothing
  
instance Applicative Maybe where
  -- pure :: a -> Maybe a 
  pure x = Just x
  -- (<*>) :: Maybe (a -> b) -> Maybe a -> Maybe b
  (Just f) <*> (Just x) = Just (f x)
  Nothing  <*> _        = Nothing
  _        <*> Nothing  = Nothing
  
instance Monad Maybe where
  -- return :: a -> Maybe a 
  return = pure
  -- (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
  (Just x) >>= f = f x 
  Nothing  >>= f = Nothing

evalMBdo :: Exp -> Maybe Int 
evalMBdo (Cte i) = return i 
evalMBdo (Add e1 e2) = 
--   (evalMBdo e1) >>= (\n1 -> (evalMBdo e2) >>= (\n2 -> return (n1+n2)))
-- do notation:
  do
  n1 <- evalMBdo e1
  n2 <- evalMBdo e2
  return (n1+n2)
evalMBdo (Div e1 e2) = do
  n1 <- evalMBdo e1  
  n2 <- evalMBdo e2  
  if (n2 == 0) then Nothing else return (n1 `div` n2) -- never use if !!!

test_eval1''' = evalMBdo e1 == Just 0

test_eval2''' = evalMBdo e2 == Nothing

-- IO: change the (state of the) world 

data IO a = IO (World -> (a,World)) 

instance Functor IO where 
  --fmap :: (a -> b) -> IO a -> IO b
  fmap f (IO g) = IO (\w0 -> let (a,w1) = g w0 in (f a,w1))

instance Applicative IO where 
  --pure :: a -> IO a
  pure x = IO (\w0 -> (x,w0))
  --(<*>) :: IO (a -> b) -> IO a -> IO b
  (IO ff) <*> (IO fa) = 
    IO (\w0 -> let (f,w1) = ff w0
                   (a,w2) = fa w1
               in (f a,w2)) 

instance Monad IO where 
  --return :: a -> IO a 
  return = pure
  --(>>=) :: IO a -> (a -> IO b) -> IO b
  (IO fa) >>= ffb = 
    IO (\w0 -> let (a,w1) = fa w0 
                   IO fb = ffb a
               in fb w1)

type World = ()

readIO :: IO String 
readIO = undefined -- unsafePerform (C.stdlib.read)

writeIO :: String -> IO () 
writeIO s = undefined -- unsafePerform (C.stdlib.write s)

-- parser 

data Parser a = Parser (String -> [(a,String)])

instance Functor Parser where 
  --fmap :: (a -> b) -> Parser a -> Parser b
  fmap f (Parser g) = Parser (\s0 -> map (\(a,s1) -> (f a,s1)) (g s0))

instance Applicative Parser where 
  --pure :: a -> Parser a 
  pure x = Parser (\s0 -> [(x,s0)])
  --(<*>) :: Parser (a -> b) -> Parser a -> Parser b 
  (Parser ff) <*> (Parser fa) = Parser (\s0 -> [ (f a,s2) | (f,s1) <- ff s0, (a,s2) <- fa s1 ])

instance Monad Parser where
  --return :: a -> Parser a 
  return = pure
  --(>>=) :: Parser a -> (a -> Parser b) -> Parser b 
  (Parser fa) >>= f = Parser (\s0 -> [ (b,s2) | (a,s1) <- fa s0, let Parser fb = f a, (b,s2) <- fb s1 ] )

instance Alternative Parser where 
  empty = Parser (\s0 -> [])
  (Parser f1) <|> (Parser f2) = Parser (\s0 -> f1 s0 ++ f2 s0)

instance MonadPlus Parser where
  -- use Alternative definitions

runP :: Parser a -> String -> [(a,String)]
runP (Parser f) s = f s

charP :: Parser Char 
charP = 
  Parser (\s0 -> case s0 of 
             "" -> []
             c:cs -> [(c,cs)])

test_P1 = runP charP "" == []
test_P2 = runP charP "abc" == [('a',"bc")]

charCharP :: Parser (Char,Char)
charCharP = do
  c1 <- charP
  c2 <- charP
  return (c1,c2)
  
test_P3 = runP charCharP "abc" == [(('a','b'),"c")]
test_P4 = runP charCharP "a" == []

satP :: (a -> Bool) -> Parser a -> Parser a 
satP f p = do
  a <- p 
  if f a then return a else empty

digitP :: Parser Char
digitP = satP (\c -> c >='0' && c <='9') charP

test_P41 = runP digitP "123" == [('1',"23")]
test_P42 = runP digitP "a23" == []

someP :: Parser a -> Parser [a]
someP p = 
  do a <- p
     as <- manyP p 
     return (a:as)
     
manyP :: Parser a -> Parser [a]
manyP p = 
  someP p 
  `mplus`   
  return []

test_P44 = runP (manyP digitP) "123a" == [("123","a"),("12","3a"),("1","23a"),("","123a")]
test_P45 = runP (manyP digitP) "a123" == [("","a123")]

-- sequences of digits 
digitsP :: Parser String
digitsP = undefined 

test_P5 = runP digitsP "123+45" == [("123","+45"),("12","3+45"),("1","23+45"),("","123+45")]
test_P6 = runP digitsP "+45" == [("","+45")]

firstP :: Parser a -> Parser a 
firstP (Parser f) = Parser (\s -> take 1 (f s))

-- the longuest sequence of digits
numP :: Parser Int 
numP = undefined 

test_P8 = runP numP "123+45" == [(123,"+45")]

-- parse a constant string (e.g. keyword)
stringP :: String -> Parser String
stringP = undefined 

-- expression with only addition of integers 
expP :: Parser Exp 
expP = undefined

test_P9 = runP expP "123+45" == [(Add (Cte 123) (Cte 45),""),(Cte 123,"+45")]

--TODO arithmetic expression with division and brackets

sumP :: Parser Exp -- sum of divisions
sumP = undefined 

divP :: Parser Exp -- divisions of atoms
divP = undefined   

atomP :: Parser Exp -- an integer or a bracketed sum
atomP = undefined 
  
test_sumP1 = runP sumP "1" == [(Cte 1,"")]
test_sumP2 = runP sumP "1+2" == [(Add (Cte 1) (Cte 2),"")]
test_sumP3 = runP sumP "1/2" == [(Div (Cte 1) (Cte 2),"")]
test_sumP4 = runP sumP "11+12/33+44" == [(Add (Cte 11) (Add (Div (Cte 12) (Cte 33)) (Cte 44)),"")]
test_sumP5 = runP sumP "11+12/(33+44)" == [(Add (Cte 11) (Div (Cte 12) (Add (Cte 33) (Cte 44))),"")]

--TODO sumP and divP look alike one another: generalize with a list of operators by increasing priority
--TODO deal with associativity declaration (infixl/infixr)
