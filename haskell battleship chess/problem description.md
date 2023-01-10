#Project Specification — proj2

The objective of this project is to practice and assess your understanding of functional programming and Haskell. You will write code to implement both the guessing and answering parts of a logical guessing game.
##The Game

Proj2 is a simple two-player logical guessing game created for this project. You will not find any information about the game anywhere else, but it is a simple game and this specification will tell you all you need to know.

The game is somewhat akin to the game of Battleship™, but somewhat simplified. The game is played on a 4×8 grid, and involves one player, the searcher trying to find the locations of three battleships hidden by the other player, the hider. The searcher continues to guess until they find all the hidden ships. Unlike Battleship™, a guess consists of three different locations, and the game continues until the exact locations of the three hidden ships are guessed in a single guess. After each guess, the hider responds with three numbers:

    the number of ships exactly located;
    the number of guesses that were exactly one space away from a ship; and
    the number of guesses that were exactly two spaces away from a ship. 

Each guess is only counted as its closest distance to any ship. For example if a guessed location is exactly the location of one ship and is one square away from another, it counts as exactly locating a ship, and not as one away from a ship. The eight squares adjacent to a square, including diagonally adjacent, are counted as distance 1 away. The sixteen squares adjacent to those squares are considered to be distance 2 away, as illustrated in this diagram of distances from the center square:
2	2	2	2	2
2	1	1	1	2
2	1	0	1	2
2	1	1	1	2
2	2	2	2	2

Of course, depending on the location of the center square, some of these locations will actually be outside the board.

Note that this feedback does not tell you which of the guessed locations is close to a ship. Your program will have to work that out; that is the challenge of this project.

We use a chess-like notation for describing locations: a letter A–H denoting the column of the guess and a digit 1–4 denoting the row, in that order. The upper left location is A1 and the lower right is H4.

A few caveats:

    The three ships will be at three different locations.
    Your guess must consist of exactly three different locations.
    Your list of locations may be written in any order, but the order is not significant; the guess A3, D1, H1 is exactly the same as H1, A3, D1 or any other permutation. 

Here are some example ship locations, guesses, and the feedback provided by the hider:
Locations	Guess	Feedback
H1, B2, D3	B3, C3, H3	0, 2, 1
H1, B2, D3	B1, A2, H3	0, 2, 1
H1, B2, D3	B2, H2, H1	2, 1, 0
A1, D2, B3	A3, D2, H1	1, 1, 0
A1, D2, B3	H4, G3, H2	0, 0, 0
A1, D2, B3	D2, B3, A1	3, 0, 0

Here is a graphical depiction of the first example above, where ships are shown as S and guessed locations are shown as G:
 	A	B	C	D	E	F	G	H
1	 	 	 	 	 	 	 	S
2	 	S	 	 	 	 	 	 
3	 	G	G	S	 	 	 	G
4	 	 	 	 	 	 	 	  	 	 	 	 	 	 	 

The game finishes once the searcher guesses all three ship locations in a single guess (in any order), such as in the last example above. The object of the game for the searcher is to find the target with the fewest possible guesses.
##The Program

You will write Haskell code to implement both the hider and searcher parts of the game. This will require you to write a function to return your initial guess, and another to use the feedback from the previous guess(es) to determine the next guess. The former function will be called once, and then the latter function will be called repeatedly until it produces the correct guess. You must also implement a function to determine the feedback to give to the searcher, given his guess and a target.

You will find it useful to keep information between guesses; since Haskell is a purely functional language, you cannot use a global or static variable to store this. Therefore, your initial guess function must return this game state information, and your next guess function must take the game state as input and return the new game state as output. You may put any information you like in the game state, but you must define a type GameState to hold this information. If you do not need to maintain any game state, you may simply define type GameState = ().

You must also define a type Location to represent grid locations in the game, and you must represent your guesses as lists of Locations. Your Location type must be an instance of the Eq type class. Of course, two Locations must be considered equal if and only if they are identical. You must also define a function to convert a Location into a two-character string of the upper-case column letter and row numeral, as shown throughout this document.
##What you must define

In summary, in addition to defining the GameState and Location types, you must define following functions:

toLocation :: String → Maybe Location
    gives Just the Location named by the string, or Nothing if the string is not a valid location name. 

fromLocation :: Location → String
    gives back the two-character string version of the specified location; for any location loc, toLocation (fromLocation loc) should return Just loc. 

feedback :: [Location] → [Location] → (Int,Int,Int)
    takes a target and a guess, respectively, and returns the appropriate feedback, as specified above. 

initialGuess :: ([Location],GameState)
    takes no input arguments, and returns a pair of an initial guess and a game state. 

nextGuess :: ([Location],GameState) → (Int,Int,Int) → ([Location],GameState)
    takes as input a pair of the previous guess and game state, and the feedback to this guess as a triple of the number of correct locations, the number of guesses exactly one square away from a ship, and the number exactly two squares away, and returns a pair of the next guess and new game state. 

You must call your source file Proj2.hs, and it must have the following module declaration as the first line of code:

  module Proj2 (Location, toLocation, fromLocation, feedback,
                GameState, initialGuess, nextGuess) where

In the interests of simplicity, please put all your code in the single Proj2.hs file.