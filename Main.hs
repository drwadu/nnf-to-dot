module Main where

import Data.List (find)
import Data.Maybe (fromJust, isJust, mapMaybe)
import System.Environment (getArgs)
import Text.Read (readMaybe)


andNodeStyle   = "[label=∧ shape=box width=0.5]"
orNodSetyle    = "[label=∨ shape=box width=0.5]"
plusNodeStyle  = "[label=\"+\" shape=box fontsize=16 width=0.5]"
timesNodeStyle = "[label=\"✕\" shape=box fontsize=20 width=0.5]"

main :: IO ()
main = do
  (file : _) <- getArgs
  contents <- readFile file
  let nnf = lines contents
  let nc = readInt $ words (head nnf) !! 1
  let mappings = mapMaybe mapping nnf
  let body = dotBody nc mappings (filter (\x -> head (words x) /= "c") nnf)
  putStr "digraph nnf2dot  {\n\tedge[arrowhead=none];"
  mapM_ putStr body
  putStrLn "\n}"

toNodes :: (Num b, Enum b) => [a] -> [(a, b)]
toNodes dag = reverse $ zip (reverse $ tail dag) [1 ..]

readInt :: String -> Integer
readInt = read :: String -> Integer

readMaybeInt :: String -> Maybe Integer
readMaybeInt = readMaybe :: String -> Maybe Integer

mapping :: String -> Maybe (Integer, String)
mapping xs =
  let ys = words xs
   in if head ys == "c"
        then Just (readInt $ head $ tail ys, last $ tail ys)
        else Nothing

negation :: (a, String) -> String
negation = (++) "¬" . snd

label :: Integer -> [(Integer, String)] -> String
label i xs =
  let y = find (\x -> fst x == abs i) xs
   in if i > 0
        then maybe ("<x<SUB>" ++ show i ++ "</SUB>>") snd y
        else maybe (((++) "<¬x<SUB>" . show $ abs i) ++ "</SUB>>") negation y

dot :: Show a => Integer -> [(Integer, String)] -> ([Char], a) -> [[Char]]
dot nc xs (node, id)
  | head node == 'L' =
    [ "\n\tNode_"
        ++ show id
        ++ " [label="
        ++ label (readInt . last . words $ node) xs
        ++ "]"
    ]
  | head node == 'A' =
    reverse ["\n\tNode_" ++ show id ++ " " ++ andNodeStyle, edges nc node id]
  | head node == 'O' =
    reverse ["\n\tNode_" ++ show id ++ " " ++ orNodSetyle, edges nc node id]
  | head node == '*' =
    reverse ["\n\tNode_" ++ show id ++ " " ++ timesNodeStyle, edges nc node id]
  | head node == '+' =
    reverse ["\n\tNode_" ++ show id ++ " " ++ plusNodeStyle, edges nc node id]
  | otherwise =
    [ "\n\tNode_" ++ show id
        ++ " [label=\""
        ++ label (fromJust . readMaybeInt . head . words $ node) xs ++ "\"]"
    ]

convertEdge n id = 
  (++) "\n" . ((++) (concat ["\tNode_", show id, " -> Node_"]) . show . abs . (-) n . readInt)

edges :: Show a => Integer -> [Char] -> a -> [Char]
edges n node id
  | head node `elem` "A*+" = concatMap (convertEdge n id) (drop 2 $ words node)
  | head node == 'O' = concatMap (convertEdge n id) (drop 3 $ words node) 
  | otherwise = error "invalid input."

dotBody :: Integer -> [(Integer, String)] -> [[Char]] -> [[Char]]
dotBody nc xs nnf = reverse $ concatMap (dot nc xs) $ toNodes nnf
