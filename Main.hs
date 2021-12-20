module Main where

import System.Environment (getArgs)

main :: IO ()
main = do
  (file : _) <- getArgs
  contents <- readFile file
  let nnf = lines contents
  let nc = readInt $ words (head nnf) !! 1
  let body = dotBody nc nnf
  let nnfStack = stack nnf
  print $ map (evalCount nnfStack) nnfStack
  putStr "digraph nnftd  {"
  mapM_ putStr body
  putStrLn "\n}"

toNodes :: (Num b, Enum b) => [a] -> [(a, b)]
toNodes dag = reverse $ zip (reverse $ tail dag) [1 ..]

readInt :: String -> Integer
readInt = read :: String -> Integer

stack :: [[Char]] -> [[Integer]]
stack = map gate . tail

gate :: [Char] -> [Integer]
gate s
  | head s == 'L' = [readInt . last . words $ s]
  | head s == 'A' = (map readInt . drop 2 . words $ s) ++ [1]
  | head s == 'O' = (map readInt . drop 3 . words $ s) ++ [0]
  | otherwise = error "invalid nnf."

evalCount :: Integral a => [[a]] -> [a] -> [a]
evalCount nnf node
  | length node == 1 = 1 : node
  | null node = 0 : node
  | otherwise = case last node of
    -- 1 -> product (map (\i -> evalCount nnf $ nnf !! fromIntegral i) $ init node) : node
    -- 0 -> sum (map (\i -> evalCount nnf $ nnf !! fromIntegral i) $ init node) : node
    _ -> error "unknown error."

dot :: Show a => Integer -> ([Char], a) -> [[Char]]
dot nc (node, id)
  | head node == 'L' = ["\n\tNode_" ++ show id ++ " [label=" ++ show (readInt . last . words $ node) ++ "]"]
  | head node == 'A' = reverse ["\n\tNode_" ++ show id ++ " [label=A]", edges nc node id]
  | head node == 'O' = reverse ["\n\tNode_" ++ show id ++ " [label=O]", edges nc node id]
  | otherwise = error "invalid nnf."

dotWIthMappings :: Show a => Integer -> ([Char], a) -> [[Char]]
dotWIthMappings = undefined

countingGraph = undefined

edges :: Show a => Integer -> [Char] -> a -> [Char]
edges n node id
  | head node == 'A' =
    concatMap
      ((++) "\n" . ((++) (concat ["\tNode_", show id, " -> Node_"]) . show . abs . (-) n . readInt))
      (drop 2 $ words node)
  | head node == 'O' =
    concatMap
      ((++) "\n" . ((++) (concat ["\tNode_", show id, " -> Node_"]) . show . abs . (-) n . readInt))
      (drop 3 $ words node)

dotBody :: Integer -> [[Char]] -> [[Char]]
dotBody nc nnf = reverse $ concatMap (dot nc) $ toNodes nnf
