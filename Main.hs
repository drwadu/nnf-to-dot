module Main where

import qualified Data.Set as Set
import System.Environment (getArgs)

main :: IO ()
main = do
 -- (file : _) <- getArgs
 -- contents <- readFile file
 -- let xs = lines contents
 -- let sts = stats xs
 -- print sts
 -- let nnf = toNnf $ tail xs
 -- let vs = map varsixs nnf
 -- let vars = map (collectVars nnf vs) vs
 -- print $ last vars
 -- print vars
  -- let nc = stats ...
  let contents = map dot $ toNodes dag 
  print contents
  return ()

toNodes :: (Num b, Enum b) => [a] -> [(a, b)]
toNodes dag = reverse $ zip (reverse $ tail dag) [1..]

stats :: [String] -> [Integer]
stats = map readInt . tail . words . head

-- let words
dot (node, id)
    | head node == 'L' =  ["\tNode_" ++  show id ++ " [label=" ++ show (readInt . last . words $ node) ++ "]"]
    | otherwise = []

-- dotFile = map dot

--

readInt :: String -> Integer
readInt = read :: String -> Integer

dropRead :: Int -> String -> [Integer]
dropRead n = drop n . map readInt . words

--gn (i, line)
toNode :: [Char] -> [Integer]
toNode line
  | head line == 'L' = dropRead 1 line
  | head line == 'A' = dropRead 2 line ++ [1]
  | head line == 'O' = dropRead 3 line ++ [0]
  | otherwise = error "invalid nnf."

toNnf :: [String] -> [[Integer]]
toNnf = map toNode


-- (ixs, vars)
varsixs :: (Ord a, Num a) => [a] -> ([a], Set.Set a)
varsixs node
  | length node == 1 = ([], Set.fromList . map abs $ node) -- literal
  | otherwise = (init node, Set.empty)

access :: Integral a => [c] -> a -> c
access xs = (xs !!) . fromIntegral 

-- TODO
collectVars nnf vars (nodeIds, nodeVars)
  | null nodeIds = nodeVars
  | otherwise = f
  where
    -- base condition wrong
    f = foldr (Set.union . collectVars nnf vars . access vars) nodeVars nodeIds

varCounts :: [Set.Set Integer] -> [Int]
varCounts = map length 

val nnf vcs node
  | length node == 1 = ("L", 1)
  | last node == 1 = ("*", sum . map (snd . val nnf vcs . access nnf) $ init node)
  | last node == 0 = ("+", (+1) $ sum . map (snd . val nnf vcs . access nnf) $ init node)
  | otherwise = error "invalid nnf."
  -- | last node == 0 = ("+", sum $ map (val nnf vcs) $ init node)
  -- | otherwise = ("Nothing", 0)
  -- 1 *, 0 +
  -- | last node == 1 = ("A", sum $ map (val nnf vcs) $ init node)
  -- | otherwise = undefined

--

--nd nnf 
--    | length node == 1 = "\tNode_"

test :: [Char]
test = "nnf 9 8 3\nL 2\nL 3\nL -1\nL -2\nL -3\nA 2 3 1\nA 2 0 4\nO 3 2 5 6\nA 2 2 7"

dag = lines test
nnf = toNnf . tail $ dag
nc = head $ stats dag

vs = map varsixs nnf
vars = map (collectVars nnf vs) vs
vcs = varCounts vars
