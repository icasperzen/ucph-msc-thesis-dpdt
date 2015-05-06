module PINQuery

import Data.Rational
import Database.PowerOfPi

Sensitivity : Type
Sensitivity = Rational

Stability : Type
Stability = Rational

data PINQuery : Schema -> Stability -> Type where
    MkLeaf   : Query s -> PINQuery s c
    MkUnary  : Query s -> PINQuery s c' -> PINQuery s c 
    MkBinary : Query s -> PINQuery s c' -> PINQuery s c'' -> PINQuery s c

getQuery : PINQuery s _ -> Query s
getQuery (MkLeaf q) = q
getQuery (MkUnary q _) = q
getQuery (MkBinary q _ _) = q

data PINQueryAggregation : Schema -> a -> Sensitivity -> Type where
    MkPINQueryAggregation : QueryAggregation s a -> PINQueryAggregation s a c

table : List (Row s) -> PINQuery s (1:%1)
table rs = MkLeaf (Table rs)

where' : PINQuery s c -> (Row s -> Bool) -> PINQuery s c 
where' pq p = MkUnary (Select (RowFn p) (getQuery pq)) pq
       
--select : PINQuery s c -> (f:String -> Maybe String)-> PINQuery (projectedSchema f s) c
--select (MkPINQuery q) f = MkUnary (Projection f q)
--
union : PINQuery s c -> PINQuery s c' -> PINQuery s (c * c')
union pq1 pq2 = MkBinary (Union (getQuery pq1) (getQuery pq2)) pq1 pq2
--
--intersection : PINQuery s c -> PINQuery s c' -> PINQuery s (c * c')
--intersection (MkPINQuery q) (MkPINQuery q') = MkPINQuery (Diff q q')

