module Basic001

import Database.PowerOfPi.Idris

Person : Schema
Person = [ "Name" ::: String , "Age" ::: Nat ]

Food : Schema
Food = [ "Name" ::: String , "Food" ::: String ]

people : Query Table Person
people = Table [ [ "Casper" , 25 ]
               , [ "Knut"   , 26 ]
               , [ "Tor"    , 26 ]
               , [ "Gismo"  ,  2 ]
               ]

foods : Query Table Food
foods = Table [ [ "Casper" , "Bruschetta" ]
              , [ "Knut"   , "Prim"       ]
              , [ "Gismo"  , "Dog food"   ]
              ]

namespace Union

  unionPeopleWithItself : Table Person
  unionPeopleWithItself = eval (people `Union` people)

  lengthUnionPeopleWithItself : length unionPeopleWithItself = 8
  lengthUnionPeopleWithItself = Refl

  unionPeopleWithNew : Table Person
  unionPeopleWithNew = eval (people `Union` (Table [["Alice",18]]))

  lengthUnionPeopleWithNew : length unionPeopleWithNew = 5
  lengthUnionPeopleWithNew = Refl

namespace Diff

  diffPeopleWithItself : Table Person
  diffPeopleWithItself = eval (people `Diff` people)

  lengthDiffPeopleWithItself : length diffPeopleWithItself = 0
  lengthDiffPeopleWithItself = Refl

  diffPeopleWithNew : List (Row Person)
  diffPeopleWithNew = eval (people `Diff` (Table [["Gismo",2]]))

  lengthDiffPeopleWithNew : length diffPeopleWithNew = 3
  lengthDiffPeopleWithNew = Refl

namespace Product

  prodPeopleWithABC : List (Row (Person ++ ["Foo":::Char]))
  prodPeopleWithABC = eval (Product people fooTable) where 
    fooTable : Query Table ["Foo":::Char]
    fooTable = Table [ [ 'A' ] , [ 'B' ] , [ 'C' ] ]

  lengthProdPeopleWithABC : length prodPeopleWithABC = 12
  lengthProdPeopleWithABC = Refl

namespace Projection

  projPeopleFirstNames : List (Row ["FirstName":::String])
  projPeopleFirstNames = eval (Projection fooProj people) where 
    fooProj : String -> Maybe String
    fooProj "Name" = Just "FirstName"
    fooProj _      = Nothing

namespace Select

  selectOneTable : List (Row Person)
  selectOneTable = eval (Select expr people) where 
    expr : Expr Person Bool
    expr = (Person ^ "Age") == (Lit 25)

  lengthSelectOneTable : length selectOneTable = 1
  lengthSelectOneTable = Refl

namespace GroupBy

  groupByAge : GroupingMap Nat Person
  groupByAge = eval (GroupBy (Person ^ "Age") people)

  lengthGroupByAge : length groupByAge = 3
  lengthGroupByAge = Refl

namespace Foo

  twentySixYOs : List (Row Person)
  twentySixYOs = eval $ Lookup 26 $ GroupBy (Person ^ "Age") people
  
  length26YOs : length twentySixYOs = 2
  length26YOs = Refl

namespace Aggregation

  countTable : eval (Aggregation people (+) (the Nat 0) (Lit 1)) = length (eval people)
  countTable = Refl

  sumAges : eval (Aggregation people (+) (the Nat 0) (Person^"Age")) = 79
  sumAges = Refl

namespace Partition

  partitionByAge : GroupingMap Nat Person
  partitionByAge = eval (Partition [2,26] (Person^"Age") people)
