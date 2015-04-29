module Database.PowerOfPi.Expr
import Database.PowerOfPi.Types
%default total

||| Looks up the Type associated with 'nm'
|||
||| @ps The schema to check
||| @k  The name to look for
lookup' : (ps:Schema) -> (map cast ps) `ContainsKey` k -> Type
lookup' (k:::v :: ps) Here = v
lookup' (k':::v :: ps) (There x) = lookup' ps x

||| Represents a typed expression.
|||
||| @s The attributes available to the expression
||| @t The return type of the expression
data Expr : (s:Schema) -> (t:Type) -> Type where
  ||| Fetches the value of the given attribute for the current row.
  |||
  ||| @s  The schema of available attributes (i.e. the current row)
  ||| @nm The name of the attribute to look up
  (^) : (s:Schema) -> (nm:String) -> { auto p : (map cast s) `ContainsKey` nm } -> Expr s (lookup' s p)
  (+) : Num t => Expr s t -> Expr s t -> Expr s t
infixl 5 ^
