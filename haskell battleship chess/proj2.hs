data Location=Location Int Int deriving (Show, Read, Eq, Ord)
data GameState=GameState [[Location]] Int deriving (Show, Read, Eq)

{-需要定义这玩意的Enum吗-}
fromLocation::Location->String
fromLocation (Location m n)= 
    if (elem m [0..7])&&(elem n [0..3]) 
        then ["ABCDEFGH"!!m,"1234"!!n]
        else error "illegal location"

toLocation::String->Maybe Location
toLocation strLoc=fmap intToLoc intLoc
    where intLoc=elemIndex strLoc strLocList
          intToLoc x=Location (div x 4) (mod x 4)
          strLocList=[[m,n]|m<-"ABCDEFGH",n<-"1234"]

feedback::[Location] -> [Location] -> (Int,Int,Int)
feedback guesses locs = (div numRes 16,div (mod numRes 16) 4,mod numRes 4)
    where numRes=feedbackNum guesses locs

{-需要计算-}
initialGuess :: ([Location],GameState)
initialGuess = ([(Location 0 0),(Location 0 0),(Location 0 0)],GameState possibleLocs 1)
    where allLocs=[Location m n|m<-[0..7],n<-[0..3]]
          possibleLocs=subList 3 allLocs

nextGuess :: ([Location],GameState) -> (Int,Int,Int) -> ([Location],GameState)
nextGuess (prevGuess,GameState rawGuesses n) curfeedback = (curguess,GameState reGuesses (n+1))
    where feedbackcode=markToCode curfeedback
          reGuesses=filter (\x->((feedbackNum prevGuess x)==feedbackcode)) rawGuesses
          curguess=getBestGuess reGuesses reGuesses
          
{------------------------------------------------------------------------------}
markToCode::(Int,Int,Int)->Int
markToCode (a,b,c)=a*16+b*4+c

feedbackNum::[Location] -> [Location] -> Int
feedbackNum guesses locs=feedbackNum' guesses locs 0
feedbackNum' [] _ n = n
feedbackNum' (g:gs) locs n
    |oneGuessRes==0 = feedbackNum' gs locs n+16
    |oneGuessRes==1 = feedbackNum' gs locs n+4
    |oneGuessRes==2 = feedbackNum' gs locs n+1
    |otherwise = feedbackNum' gs locs n
    where oneGuessRes=minimum (map (dist g) locs)
          dist (Location x1 y1) (Location x2 y2)=max (abs (x1-x2)) (abs (y1-y2))
  
subList::Int->[a]->[[a]]
subList 0 _ = [[]]
subList _ [] = []
subList n (l:ls) = (map (l:) (subList (n-1) ls))++(subList n ls)  

{-需要验证：因为Haskell的懒求值特性，先平方再求和是否比fold更慢-}
sumRemains locs guess=sum.(map (^2)) $ answerNumbs
    where answerNumbs=map length (group.sort $ map (feedbackNum guess) locs)

getBestGuess locs guesses=target
    where (_,target)=minimum (map (\x->((sumRemains locs x),x)) guesses)

showBestGuess locs guesses = take 10 (sort (map (\x->((sumRemains locs x),x)) guesses))

{------------------------------------------------------------------------------}
loc1=[Location 8 1,Location 2 2, Location 4 3]
loc2=[Location 1 1,Location 4 2, Location 2 3]
gus1=[Location 2 3,Location 3 3, Location 8 3]
gus2=[Location 2 1,Location 1 2, Location 8 3]
gus3=[Location 2 1,Location 8 2, Location 8 1]
gus4=[Location 1 3,Location 4 2, Location 8 1]
gus5=[Location 8 1,Location 7 3, Location 8 2]
gus62=[Location 4 2,Location 2 3, Location 1 1]