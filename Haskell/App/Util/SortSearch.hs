module App.Util.SortSearch where

import qualified Data.Maybe
import Data.List (maximumBy, sort)
import Data.Function (on)
import Data.Ord (comparing)

merge :: (a -> Int) -> [a] -> [a] -> [a]
merge _ [] ys         = ys
merge _ xs []         = xs
merge func (x:xs) (y:ys)
    | func x > (func y)       = x:merge func xs (y:ys)
    | otherwise                     = y:merge func (x:xs) ys

halve :: [a] -> ([a],[a])
halve xs = (take metade xs, drop metade xs)
           where metade = length xs `div` 2

msort :: (a -> Int) -> [a] -> [a]
msort _ []  = []
msort _ [x] = [x]
msort func  xs = merge func (msort func left) (msort func right)
            where (left,right) = halve xs

searchBy ::(Eq b) => (a -> b) -> [a] -> b -> Maybe a
searchBy _ [] _ = Nothing
searchBy func (x:xs) item
    | func x == item    = Just x
    | otherwise         = searchBy func xs item

searchsBy :: (Eq b) => (a -> b) -> [a] -> [b] -> [a]
searchsBy _ [] _    = []
searchsBy _ _ []    = []
searchsBy func (x:xs) resultados
    | func x `elem` resultados  = x : searchsBy func xs resultados
    | otherwise                 = searchsBy func xs resultados


removeBy :: (Eq b) => (a -> b) -> [a] -> b -> [a]
removeBy _ [] _ = []
removeBy func (x:xs) result
    | func x == result  = removeBy func xs result
    | otherwise         = x : removeBy func xs result

removeFrom :: Eq b => (a -> b) -> [a] -> [a] -> [a]
removeFrom f xs ys = [x | x <- xs, not (f x `elem` mappedYs)]
    where mappedYs = map f ys
    
mostFrequentElement :: (Ord b) => (a -> [b]) -> [a] -> b
mostFrequentElement f xs = mostFreq $ concatMap f xs
  where
    mostFreq = head . maximumBy (comparing length) . groupSort

groupSort :: (Ord a) => [a] -> [[a]]
groupSort = group . sort
  where
    group [] = []
    group (x:xs) = (x : takeWhile (==x) xs) : group (dropWhile (==x) xs)

secondMostFrequentElement :: (Ord b) => (a -> [b]) -> [a] -> b
secondMostFrequentElement f xs = head ((mostFreq $ concatMap f xs) !! 1)
    where mostFreq = msort (length) . groupSort