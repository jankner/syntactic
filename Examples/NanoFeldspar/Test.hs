import Prelude hiding (length, map, (==), max, min, reverse, sum, unzip, zip, zipWith)

import Language.Syntactic.Constructs.TupleSyntacticSimple

import NanoFeldspar.Core
import NanoFeldspar.Extra
import NanoFeldspar.Vector



prog1 :: Data Int -> Data Int -> Data Int
prog1 a b = min (max a (getIx (parallel b (\i -> min i b)) 3)) 2

test1_1 = drawFeld prog1
test1_2 = printFeld prog1
test1_3 = eval prog1 0 10

prog2 :: Data Int -> Data Int
prog2 a = let b = min a a in max b b

test2_1 = drawFeld prog2
test2_2 = printFeld prog2
test2_3 = eval prog2 34

prog3 :: Data Index
prog3 = sum $ reverse (10...45)

test3_1 = drawFeld prog3
test3_2 = printFeld prog3
test3_3 = eval prog3
test3_4 = eval (forLoop ((45 - 10) + 1) 0 (\var0 -> (\var1 -> ((((((45 - 10) + 1) - var0) - 1) + 10) + var1))))
  -- Pasted in the result of 'test3_2'

prog4 :: Vector (Data Index)
prog4 = map (uncurry (*)) $ zip (1...1000) (value [34,43,52,61])

test4_1 = drawFeld prog4
test4_2 = printFeld prog4
test4_3 = eval prog4

prog5 :: Vector (Data Index) -> Vector (Data Index)
prog5 = zipWith (*) (1...1000)

test5_1 = drawFeld prog5
test5_2 = printFeld prog5
test5_3 = eval prog5 [20..30]

prog6 :: Data Index -> Data Index
prog6 a = share (a*2,a*3) $ \(b,c) -> (b-c)*(c-b)

test6_1 = drawFeld prog6
test6_2 = printFeld prog6
test6_3 = eval prog6 20



--------------------------------------------------------------------------------
-- Demonstration of common sub-expression elimination and observable sharing
--------------------------------------------------------------------------------

prog7 = index as 1 + sum as + sum as
  where
    as = map (*2) $ force (1...20)

test7_1 = drawFeld prog7
  -- Draws a tree with no duplication

test7_2 = drawFeldCSE prog7
  -- Draws a graph with no duplication

test7_3 = drawFeldObs prog7
  -- Draws a graph with some duplication. The 'forLoop' introduced by 'sum' is
  -- not shared, because 'sum as' is repeated twice in source code. But the
  -- 'parallel' introduced by 'force' is shared, because 'force' only appears
  -- once.



--------------------------------------------------------------------------------
-- Demonstration of partial evaluation
--------------------------------------------------------------------------------

prog8 :: Data Int -> Data Int
prog8 a = (a==10) ? (max 5 (6+7), max 5 (6+7))

test8 = drawFeldPart prog8

prog9 a = expensiveCond ? (parallel a (+a), parallel a (+a))
  where
    expensiveCond = getIx (parallel (a*a*a*a) (+a)) 10 == 23

test9 = drawFeldPart prog9

