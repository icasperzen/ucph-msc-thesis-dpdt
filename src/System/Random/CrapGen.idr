module System.Random.CrapGen
import Data.Vect
%default total
{-
   CrapGen comes directly from Idris' own Effect.Random module.
   It doesn't seem to be particularly good and should probably be replaced with a CSPRING.
-}

-- TODO : Replace this with a CSPRNG
CrapGen : Type
CrapGen = Integer

||| Generate a random Integer between the given bounds.
%assert_total
rndInt : Integer -> Integer -> CrapGen -> (Integer,CrapGen)
rndInt lower upper seed = let r = (1664525 * seed + 1013904223 `prim__sremBigInt` (pow 2 32))
                              v = (r `prim__sremBigInt` (upper - lower)) + lower
                           in (v,v)

||| Generate a random Double between 0 and 1.
rndDouble : CrapGen -> (Double,CrapGen)
rndDouble g = let upper = 4000000000
                  (ri,g') = rndInt 0 upper g
               in (fromInteger ri / fromInteger upper, g')

||| Unfolds a CrapGen infinitely
unfoldCrapGen : CrapGen -> Stream (Float,CrapGen)
unfoldCrapGen g = let (u,g') = rndDouble g
                 in (u,g') :: unfoldCrapGen g'

||| Take exactly n items from a Stream
take' : (n:Nat) -> Stream a -> Vect n a
take' Z     xs        = []
take' (S k) (x :: xs) = x :: take' k xs

||| Unfolds a CrapGen `n` times
unfoldCrapGenN : (n:Nat) -> CrapGen -> Vect n (Float,CrapGen)
unfoldCrapGenN n = take' n . unfoldCrapGen

