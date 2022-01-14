module Main where

import Data.Maybe
import System.Environment (getArgs)
import Text.Read (readMaybe)

main :: IO ()
main = do
  (file : _) <- getArgs
  contents <- readFile file
  let nnf = lines contents
  let nc = readInt $ words (head nnf) !! 1
  let body = dotBody nc nnf

  putStr "digraph nnftd  {"
  mapM_ putStr body
  putStrLn "\n}"

toNodes :: (Num b, Enum b) => [a] -> [(a, b)]
toNodes dag = reverse $ zip (reverse $ tail dag) [1 ..]

readInt :: String -> Integer
readInt = read :: String -> Integer

readMaybeInt :: String -> Maybe Integer
readMaybeInt = readMaybe :: String -> Maybe Integer

dot :: Show a => Integer -> ([Char], a) -> [[Char]]
dot nc (node, id)
  | head node == 'L' =
    [ "\n\tNode_"
        ++ show id
        ++ " [label="
        ++ show (readInt . last . words $ node)
        ++ "]"
    ]
  | head node `elem` ['A', 'O'] =
    reverse
      [ "\n\tNode_"
          ++ show id
          ++ " [label="
          ++ show (head . words $ node)
          ++ " shape=box]",
        edges nc node id
      ]
  | head node == '*' =
    reverse
      [ "\n\tNode_" ++ show id ++ " [label=\"* ↦ "
          ++ show (readInt . last . words $ node)
          ++ "\" shape=box]",
        edges nc node id
      ]
  | head node == '+' =
    reverse
      [ "\n\tNode_" ++ show id ++ " [label=\"+ ↦ "
          ++ show (readInt . last . words $ node)
          ++ "\" shape=box]",
        edges nc node id
      ]
  | otherwise =
    [ "\n\tNode_" ++ show id
        ++ " [label=\""
        ++ show (fromJust . readMaybeInt . head . words $ node)
        ++ " ↦ "
        ++ show (fromJust . readMaybeInt . last . words $ node)
        ++ "\"]"
    ]

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
  | head node == '*' =
    concatMap
      ((++) "\n" . ((++) (concat ["\tNode_", show id, " -> Node_"]) . show . abs . (-) n . readInt))
      (drop 2 $ words node)
  | head node == '+' =
    concatMap
      ((++) "\n" . ((++) (concat ["\tNode_", show id, " -> Node_"]) . show . abs . (-) n . readInt))
      (drop 2 $ words node)
  | otherwise = error "invalid file."

dotBody :: Integer -> [[Char]] -> [[Char]]
dotBody nc nnf = reverse $ concatMap (dot nc) $ toNodes nnf
