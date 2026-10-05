
-- This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs License 
-- https://creativecommons.org/licenses/by-nc-nd/4.0/
-- Remi Douence

-- Please do not distribute solutions but let people learn by doing the exercices.

{-# OPTIONS_GHC -Wno-x-partial #-} 

import Prelude hiding (lex)
import Data.Char (isSpace,isDigit,isUpper)

-- compiler = transformation from source to target (+ static analysis, + optim)

-- C compiler (from C to assembly language)

-- source/target for : 
-- - human 
-- - debugger (XML) 
-- - program 

-- compiler :: Source -> Target 
-- compiler = show . transfo . parse 

data Exp
  = Add Exp Exp
  | Mul Exp Exp
  | Cte Int
  deriving (Show,Eq) 

eval :: Exp -> Int 
eval (Add e1 e2) = eval e1 + eval e2 
eval (Mul e1 e2) = eval e1 * eval e2 
eval (Cte n) = n 

e1 = Add (Cte 1) (Mul (Cte 2) (Cte 3))
e2 = Mul (Add (Cte 1) (Cte 2)) (Cte 3)

test1_eval = eval e1 == 7
test2_eval = eval e2 == 9

showExp :: Exp -> String 
showExp (Add e1 e2) = "(" ++ showExp e1 ++ " + " ++ showExp e2 ++ ")"
showExp (Mul e1 e2) = "(" ++ showExp e1 ++ " * " ++ showExp e2 ++ ")"
showExp (Cte n) = show n 

test1_showExp = showExp e1 == "(1 + (2 * 3))"
test2_showExp = showExp e2 == "((1 + 2) * 3)"

-- parser = inverse of showExp

-- non contextual grammar rule: Symbol -> Symbol ... Symbol 

-- grammar group symbol (into a tree)

-- check grammar: 
-- - dead code (rules)
-- - non termination
-- - left recursion
-- - etc.

-- grammar = an (infinite) set of programs (Yes / No) 
-- grammar = group words in tree
-- 
-- tree derivations from grammar (beware of ambiguity)
-- E ::= E + E 
-- E ::= int 
-- 
-- ambiguous:
-- 1 + 2 + 3 or 1 + 2 + 3
--
-- 1 - 2 - 3 or 1 - 2 - 3

-- deterministic parser: decide S derives to A, or S derives to B

-- grammar G0
-- S ::= A 
-- S ::= B 
-- A ::= A'
-- A ::= a
-- B ::= B'
-- B ::= b

-- grammar G1 (arbitrary prefetch + left rec + ambiguous)
-- E ::= E + E 
-- E ::= E * E 
-- E ::= int

-- grammar G2 (2 prefetch + no left rec + subset of trees + subset of exp)
-- E ::= int + E
-- E ::= int * E
-- E ::= int

-- grammar G3 (arbitrary prefetch + not ambiguous)
-- E ::= ( E + E )
-- E ::= ( E * E ) 
-- E ::= int

-- grammar G4 (1 prefetch + not ambiguous)
-- E ::= ( E F E )
-- E ::= int
-- F ::= + 
-- F ::= * 

-- grammar G5 (empty production)
-- E ::= int F
-- F ::= + E
-- F ::= 

-- grammar G6 (1 prefetch + operators priority)
-- E  ::= F E' 
-- E' ::= + E 
-- E' ::= 
-- F  ::= T F'
-- F' ::= * F
-- F' ::= 
-- T  ::= int
-- T  ::= ( E )


-- PHASE 1 - lexer

-- regular language / finite state automata (FIL A1)
-- - sequence : RR 
-- - choice   : R|R 
-- - repeat   : R*
-- - example  : int = digit digit*

data Token 
  = Open
  | Close
  | Plus
  | Star 
  | Val Int
  | End
  deriving (Show,Eq)

lexer :: String -> [Token]
lexer ('(':cs) = Open:lexer cs
lexer (')':cs) = Close:lexer cs
lexer ('+':cs) = Plus:lexer cs
lexer ('*':cs) = Star:lexer cs
lexer (c:cs) | isSpace c = lexer cs
lexer (c:cs) | isDigit c = Val (read (c:takeWhile isDigit cs)):lexer (dropWhile isDigit cs)
lexer "$" = [End]
lexer "" = []

test1_lexer = lexer "(1 + (2 * 3))" == [Open,Val 1,Plus,Open,Val 2,Star,Val 3,Close,Close]

test2_lexer = lexer "((1 + 2) * 3)$" == [Open,Open,Val 1,Plus,Val 2,Close,Star,Val 3,Close,End]

-- PHASE 2 - parser 

-- set

type Set a = [a]

listToSet :: Eq a => [a] -> Set a 
listToSet (x:xs) = x:listToSet (filter (/=x) xs)
listToSet [] = []

union :: Eq a => Set a -> Set a -> Set a 
union xs ys = xs ++ [ y | y <- ys, y `notElem` xs ]

test1_union = "abce" `union` "cdea" == "abced"

-- grammar 

type Symbol = String

isNonTerminal :: Symbol -> Bool
isNonTerminal (c:cs) = isUpper c

isTerminal :: Symbol -> Bool -- aka Token
isTerminal = not . isNonTerminal

type NonTerminal = Symbol

type Terminal = Symbol 

type Rule = (NonTerminal,[Symbol])

type Grammar = [Rule]

g1 = [ ("E",["E","+","E"])
     , ("E",["int"])
     ]
  
nonTerminalG :: Grammar -> Set Symbol
nonTerminalG g = listToSet [ lhs | (lhs,rhss) <- g ] 

terminalG :: Grammar -> Set Symbol
terminalG g = listToSet [ s | (lhs,rhss) <- g, s <- rhss, isTerminal s ] 

-- property 

type Var = String

type Prop = [ (Var,Set Symbol) ]

get :: Var -> Prop -> Set Symbol
get x ((y,ss):p)
  | x == y = ss
  | x /= y = get x p
get x [] = []

add :: (Var,Set Symbol) -> Prop -> Prop
add (x,ss') ((y,ss):p)
  | x == y = (y,union ss ss'):p
  | x /= y = (y,ss):add (x,ss') p
add (x,ss') [] = [(x,ss')]

-- FIRST
-- initFirst: t  = {t}
-- initFirst: nt = {}
--
-- rule: X -> Y_1 ... Y_n
-- equationFirst: first X = first Y_1 

initFirst :: Grammar -> Prop
initFirst g = [ (t,[t]) | t <- terminalG g ] ++ [ (nt,[]) | nt <- nonTerminalG g ]

type Equation = (NonTerminal,Symbol) -- (X,Y) means X = X `union` Y

apply :: Equation -> Prop -> Prop
apply (x,y) p = add (x,get x p `union` get y p) p

applyS :: [Equation] -> Prop -> Prop
applyS es p = foldr apply p es

equationsFirst :: Grammar -> [Equation]
equationsFirst g = [ (lhs,rhs) | (lhs,rhs:rhss) <- g ]

fixpoint :: Eq a => (a -> a) -> a -> a 
fixpoint f x
  | x == f x = x
  | otherwise = fixpoint f (f x)

firstG :: Grammar -> Prop
firstG g = fixpoint (applyS (equationsFirst g)) (initFirst g)

test1_firstG = firstG g1 == [ ("+",["+"]), ("int",["int"]), ("E",["int"]) ]

g6 :: Grammar 
g6 = [ ("E",["F","E'"])
     , ("E'",["+","E"])
     , ("E'",[])
     , ("F",["T","F'"])
     , ("F'",["*","F"])
     , ("F'",[])
     , ("T",["int"])
     , ("T",["(","E",")"])
     ]
     
test2_firstG = firstG g6 

g4 = [("E",["(","E","Op","E",")"]),("E",["int"]),("Op",["+"]),("Op",["*"])]

test4_firstG = firstG g4 
  == [ ("(",["("])
     , (")",[")"])
     , ("int",["int"])
     , ("+",["+"])
     , ("*",["*"])
     , ("E",["int","("])
     , ("Op",["*","+"])
     ]

-- g4 descendant parser (with first only)

parseOp :: [Token] -> (Exp -> Exp -> Exp,[Token]) 
parseOp (Plus:ts) = (Add,ts)
parseOp (Star:ts) = (Mul,ts)

parseE :: [Token] -> (Exp,[Token]) 
parseE (Val n:ts) = (Cte n,ts)
parseE (Open:ts) = 
  let (e1,ts1) = parseE ts
      (op,ts2) = parseOp ts1
      (e2,Close:ts3) = parseE ts2
  in (op e1 e2,ts3)

test1_parseE = parseE [Open,Val 1,Plus,Open,Val 2,Star,Val 3,Close,Close] 
  == (Add (Cte 1) (Mul (Cte 2) (Cte 3)),[])

-- FOLLOW property 
-- rule: X -> Y_1 ... Y_n
-- initFollow:     follow Y_i = first Y_i+1 
-- equationFollow: follow Y_n = follow_X

pairs :: [a] -> [(a,a)]
pairs (x1:x2:xs) = (x1,x2):pairs (x2:xs)
pairs _ = []

initFollow :: Grammar -> Prop
initFollow g = undefined

equationsFollow :: Grammar -> [Equation]
equationsFollow g = undefined  

followG :: Grammar -> Prop
followG g = fixpoint (applyS (equationsFollow g)) (initFollow g)

test1_followG = followG g1 == [("+",["int"]),("E",["+"]),("int",["+"])]
test4_followG = followG g4 
  == [ ("E",[")","*","+"])
     , ("Op",["int","("])
     , ("(",["int","("])
     , ("*",["int","("])
     , ("+",["int","("])
     , ("int",[")","*","+"])
     , (")",[")","*","+"])
     ]

test6_followG = followG g6 
  == [ ("E",[")"])
     , ("(",["(","int"])
     , ("*",["(","int"])
     , ("T",["*"])
     , ("+",["(","int"])
     , ("F",["+"])
     , (")",["*"])
     , ("int",["*"])
     , ("F'",["+"])
     , ("E'",[")"])
     ]

-- NULLABLE property
-- rule: X -> 
-- initNull: X 
-- 
-- rule: X -> Y_1 ... Y_n   and Null Y_1 && ... && Null Y_2
-- stepNull: X 

initNull :: Grammar -> Set NonTerminal
initNull g = undefined

stepNull :: Grammar -> Set NonTerminal -> Set NonTerminal
stepNull g ns = undefined

nullG :: Grammar -> Set NonTerminal
nullG g = fixpoint (stepNull g) (initNull g)

test6_nullG = nullG g6 == ["E'","F'"]

-- subgrammar (see subList in Lab3) 

subRhs :: Set Symbol -> [Symbol] -> [[Symbol]]
subRhs = undefined

subGrammar :: Grammar -> Grammar 
subGrammar g = [ (lhs,rhss') | let ns = nullG g, (lhs,rhss) <- g, rhss' <- subRhs ns rhss ]

test6_subGrammar = subGrammar g6
  == [ ("E",["F"])
     , ("E",["F","E'"])
     , ("E'",["+","E"])
     , ("E'",[])
     , ("F",["T"])
     , ("F",["T","F'"])
     , ("F'",["*","F"])
     , ("F'",[])
     , ("T",["int"]) 
     , ("T",["(","E",")"])
     ]

-- FIRST with NULLABLE

firstG' :: Grammar -> Prop 
firstG' = firstG . subGrammar

test6_firstG' = firstG' g6
  == [ ("+",["+"])
     , ("*",["*"])
     , ("int",["int"])
     , ("(",["("])
     , (")",[")"])
     , ("E",["(","int"])
     , ("E'",["+"])
     , ("F",["(","int"])
     , ("F'",["*"])
     , ("T",["(","int"])
     ]

-- FOLLOW with NULLABLE

followG' :: Grammar -> Prop 
followG' = followG . subGrammar

test6_followG' = followG' g6
  == [ ("E",[")"])
     , ("(",["(","int"])
     , ("*",["(","int"])
     , ("T",["*","+",")"])
     , ("+",["(","int"])
     , ("F",["+",")"])
     , (")",["*","+",")"])
     , ("int",["*","+",")"])
     , ("F'",["+",")"])
     , ("E'",[")"])
     ]

-- g6 descendant parser 

parseExp :: [Token] -> (Exp,[Token])
parseExp (Val n:ts) = -- first
  let (f ,ts1) = parseF (Val n:ts) in parseE' f ts1
parseExp (Open:ts) = -- first
  let (f ,ts1) = parseF (Open:ts) in parseE' f ts1

parseE' :: Exp -> [Token] -> (Exp,[Token])
parseE' e (Plus:ts) = undefined 
parseE' e (Close:ts) = undefined
parseE' e [] = undefined 

parseF :: [Token] -> (Exp,[Token])
parseF = undefined 

parseF' :: Exp -> [Token] -> (Exp,[Token])
parseF' = undefined 

parseT :: [Token] -> (Exp,[Token])
parseT = undefined 

test0_parseExp = parseExp (lexer "1") == (Cte 1,[])
test1_parseExp = parseExp (lexer "1 + 2 * 3") == (Add (Cte 1) (Mul (Cte 2) (Cte 3)),[])
test2_parseExp = parseExp (lexer "1 + (2 * 3)") == (Add (Cte 1) (Mul (Cte 2) (Cte 3)),[])
test3_parseExp = parseExp (lexer "(1 + 2) * 3") == (Mul (Add (Cte 1) (Cte 2)) (Cte 3),[])


-- ASCENDANT (LR): https://en.wikipedia.org/wiki/LALR_parser
 