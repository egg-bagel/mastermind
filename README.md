# mastermind
Mastermind game from TOP Ruby course

In this Mastermind game, the player can choose to either guess a code set by the 
computer opponent or make their own code for the computer opponent to guess. 
This game is played in the terminal.

++++++++++++++++++++++++++++++++
RULES
++++++++++++++++++++++++++++++++
The codemaker chooses a four-letter code from letters A through H. Duplicates are not allowed.
The codebreaker has 12 turns to try to guess the code.
After every guess, the codemaker must provide feedback about how good the guess was.
This feedback is in the form of four integers that are either 0, 1, or 2.
A 1 means that a letter is both in the code and in the right place in the guess.
A 2 means that a letter is in the code, but in the wrong place in the guess.
A 0 means that the letter is not in the code. 
An image of the board with all previous guesses and feedback is printed out at the end of each turn.

+++++++++++++++++++++++++++++++
EASY MODE VS. HARD MODE
+++++++++++++++++++++++++++++++
If the player chooses to be the codebreaker:
  In easy mode, the order of the feedback that the computer provides corresponds to the order
  of the letters in the player's guess. That is, if the player guesses "A B C D" and the 
  computer gives the feedback "1 0 1 2", it means that the letters A and C are in the correct
  places, the letter D is in the code but not in the correct place, and the letter B is not in 
  the code.

  In hard mode, the feedback is sorted before it is returned. In the example given previously, 
  the feedback returned would not be "1 0 1 2" but "0 1 1 2". This means the player knows how many
  letters are in the code and placed correctly, but they do not know exactly which letters those are.

If the player chooses to be the codemaker:
  In easy mode, the computer guesses randomly every turn. The computer does not learn from 
  the feedback the player gives.

  In hard mode, the computer learns from previous feedback. If a letter gets a 1 for 
  feedback, the computer keeps that letter in place. If a letter gets a 2 for feedback, it is included
  in subsequent guesses. If a letter gets a 0 for feedback, it is excluded from future guesses.
  The computer always guesses the code within 4 turns on hard mode. 

  +++++++++++++++++++++++++++++
  NOTES
  +++++++++++++++++++++++++++++
  The logic to make the computer smart when the player is the codemaker was by far the hardest
  part of this game to code. It took several days of debugging to get it to work right. 
  I googled a lot of stuff but I didn't look up any code/tutorials/hacks for making this specific game. 
