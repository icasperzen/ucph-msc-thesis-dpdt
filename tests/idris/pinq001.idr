module PINQ001

import Database.PINQ.Idris
import System.Random.CrapGen

Person : Schema
Person = [ "Name" ::: String , "Age" ::: Double ]

Food : Schema
Food = [ "Name" ::: String , "Food" ::: String ]

people : PINQuery Table Person 1
people = MkPINQuery $ Table [ [ "Casper" , 26 ]
                            , [ "Knut"   , 26 ]
                            , [ "Gismo"  ,  2 ]
                            ]

foods : PINQuery Table Food 1
foods = MkPINQuery ( Table [ [ "Casper" , "Bruschetta" ]
                           , [ "Knut"   , "Prim"       ]
                           , [ "Gismo"  , "Dog food"   ]
                           ])

namespace Aggregations

  nestedAggrs : Private 3 Double
  nestedAggrs = do x <- noisyCount people 1
                   y <- noisyCount people 2
                   return ((x+y*2)/3)

  testNoisyCount : Double
  testNoisyCount = evalPrivate (do x <- noisyCount people 1
                                   y <- noisyCount people 1
                                   return ((x+y)/2)
                               ) 123

  testNoisyAverage : Double
  testNoisyAverage = evalPrivate (do avg <- noisyAverage (PureFn (/26.0) (Person^"Age")) people 1
                                     return avg) 123

