# mastermind
Mastermind game from TOP Ruby course

All right, so how am I going to approach this? I am using classes and objects to make this game.

So like in tic-tac-toe, I will need a game class, and each new game creates a new game object from that class.
I will also need a player class. The new game calls the player class to instantiate a new player.
I will probably also need a computer player class that makes the code and provides feedback.

How is the game played? I'm going to play it in the console and use letters to represent colors. 
I'm going to do this like tic-tac-toe and print out a visual of the board after every turn.
The board grid needs to be 8 x 12, or maybe 5 x 12 if I just want to put the results all in one bigger space.

I'm going to use eight colors, R(ed) G(reen) B(lue) Y(ellow) O(range) P(ink) V(iolet) W(hite).
For the feedback I'll use 2 for right color, right place and 1 for right color, wrong place.

The computer randomly generates a combination of four of the letters. This value is saved as the solution.
The player is prompted to input a guess, which is a string of four letters.
This combination is checked against the solution.
The board is printed with the user's guess and the computer's feedback.
