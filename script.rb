class Game

  LETTER_CHOICES = ["A", "B", "C", "D", "E", "F", "G", "H"]

  def initialize
    @board = Array.new(12) { Array.new(8, "x") }
    @guesses_left = 12
    puts "Welcome to my Mastermind game!"
  end

  def play
    puts "Do you want to be the codemaker or the codebreaker? Enter your choice: "
    choice = gets.chomp.downcase
    unless choice == "codemaker" || choice == "codebreaker"
      puts "Invalid input! Please try again: "
      choice = gets.chomp
    end

    if choice == "codemaker"
      play_codemaker
    elsif choice == "codebreaker"
      play_codebreaker
    end
  end

  def print_board
    current_board = @board
    current_board.each do |row|
      draw_row(row)
      print "\n"
    end
    print "+---+---+---+---+---+---+---+---+\n"
  end

  def draw_row(row)
    print "+---+---+---+---+---+---+---+---+\n"
    i = 0
    while i <= 7
      print "| #{row[i]} "
      i += 1
    end
    print "|"
  end

#==================================================================================================================
# CODEBREAKER METHODS
#==================================================================================================================

  def play_codebreaker

    @code = LETTER_CHOICES.sample(4)

    puts "=============================================================================="
    puts "You have 12 turns to try to guess the computer's four-letter code."
    puts "The computer gives you feedback next to your guesses on the board."
    puts "A 2 means that one of your letters is in the code, but you guessed the wrong position."
    puts "A 1 means that one of your letters is in the code, and you guessed the right position."
    puts "A 0 means that you guessed a letter that is not in the code."
    puts "Good luck!"

    while @guesses_left > 0
      guess = get_guess
      feedback = compare_guess(guess)
      store_feedback(feedback)

      print_board

      if guess == @code
        puts "Congratulations! You guessed the code correctly."
        break
      end

      @guesses_left -= 1
    end
    
    if @guesses_left == 0
      puts "You're out of guesses. Better luck next time!"
    end
    
  end

  #Prompts the player to input their guess.
  #Checks the guess for validity.
  #Writes the guess to the board array.
  def get_guess
    puts "Valid choices: A B C D E F G H"
    puts "Enter your 4-letter guess, separating the letters with spaces: "
    guess = gets.chomp.upcase.split(" ")
    while input_error(guess)
      puts "Invalid input! Please try again. Hint: use uppercase and put spaces between the letters."
      puts "Valid choices: R B G Y O V P W"
      puts "Enter your 4-letter guess, separating the letters with spaces: "
      guess = gets.chomp.split(" ")
    end

    i = 0
    while i <= 3
      @board[@guesses_left - 1][i] = guess[i]
      i += 1
    end

    return guess
  end

  #Checks that the user input is valid and the correct length
  def input_error(input)
    if input.length != 4
      return true
    else
      input.each do |item|
        if LETTER_CHOICES.include?(item)
          next
        else
          return true
        end
      end
    end
    return false
  end

  #Generates a feedback array reflecting the accuracy of the guess.
  def compare_guess(guess)
    feedback_array = []
    code = @code

    i = 0
    while i <= 3
      if code.include?(guess[i])
        if code[i] == guess[i]
          feedback_array.push(1)
        else
          feedback_array.push(2)
        end
      else
        feedback_array.push(0)
      end
      i += 1
    end
    return feedback_array
  end

  #Writes the computer's feedback to the board.
  def store_feedback(feedback_array)
    current_row = @guesses_left - 1
    i = 0
    while i <= 3
      @board[current_row][i + 4] = feedback_array[i]
      i += 1
    end
  end

#=================================================================================================================
# CODEMAKER METHODS
#=================================================================================================================

  def play_codemaker

    puts "=============================================================================="
    puts "The computer has 12 tries to guess a four-letter code of your choosing."
    puts "After each of the computer's guesses, you return feedback on the accuracy of the guess."
    puts "Your feedback must be a list of four integers from 0-2. For example: 0 1 2 2"
    puts "A 2 means that one of the letters is in your code, but the computer guessed the wrong position."
    puts "A 1 means that one of the letters is in your code, and the computer guessed the right position."
    puts "A 0 means that the computer guessed a letter that is not in your code."
    puts "Good luck!"

    @code = make_code

    while @guesses_left > 0
      guess = computer_make_guess
      get_player_feedback(guess)

      print_board

      if guess == @code
        puts "You lose! The computer guessed your code."
        break
      end
      
      @guesses_left -= 1
    end

    if @guesses_left == 0
      puts "You win! The computer ran out of turns before it could guess your code."
    end
  end

  #Prompts the player to set the code for the computer to guess.
  def make_code
    puts "Enter the four-letter code you want the computer to guess.\n"
         "Separate the letters with spaces.\n"
         "Valid letter choices: A B C D E F G H"
    code = gets.chomp.upcase.split(" ")
    while check_code_input(code)
      puts "Invalid input! Please try again: "
      code = gets.chomp.upcase.split(" ")
    end
    return code
  end

  #Checks the player's code for validity.
  def check_code_input(code)
    if code.length != 4
      return true
    else 
      code.each do |letter|
        if LETTER_CHOICES.include?(letter)
          next
        else
          return true
        end
      end
    end
    return false
  end

  #Gets a guess from the computer by generating a four-letter array from LETTER_CHOICES.
  #Writes the guess to the board array.
  def computer_make_guess
    guess = LETTER_CHOICES.sample(4)

    i = 0
    while i <= 3
      @board[@guesses_left - 1][i] = guess[i]
      i += 1
    end

    puts "The computer guessed #{guess.join(" ")}."
    return guess

  end

  #Prompts the player to enter feedback on the computer's guess.
  #Stores the feedback in the board array.
  def get_player_feedback(guess)
    puts "Enter your feedback as a set of four numbers.\n"
         "Valid input: 0, 1, 2"
    feedback = gets.chomp.split(" ")

    #If the feedback is invalid or inaccurate, the player is prompted to re-enter it.
    unless check_feedback(feedback, guess)
      feedback = gets.chomp.split(" ")
    end

    #If the feedback is good, write it to the second half of the current row.
    write_player_feedback(feedback)
      
  end

  #Writes the player's feedback to the current row.
  def write_player_feedback(feedback)
    current_row = @guesses_left - 1
    i = 0
    while i <= 3
      @board[current_row][i + 4] = feedback[i]
      i += 1
    end
  end

  def check_feedback(feedback, guess)
    #First check the validity of the input
    if feedback.length != 4
      puts "Invalid input, please try again: "
      return false
    else
      feedback.each do |num|
        a = [0, 1, 2]
        unless a.include?(num.to_i)
          puts "Invalid input, please try again: "
          return false
        end
      end
    end

    #Next check the accuracy of the input
    code = @code
    feedback_verify = []
  
    i = 0
    while i <= 3        
      if code.include?(guess[i])
        if code[i] == guess[i]
          feedback_verify.push(1)
        else            
          feedback_verify.push(2)
        end
      else
        feedback_verify.push(0)
      end
      i += 1      
    end

    feedback.map! { |x| x.to_i}
    if feedback == feedback_verify
      return true
    else
      puts "It looks like your feedback isn't accurate. Please try again: "
      return false
    end

  end

end

test = Game.new()
test.play
puts "Do you want to play again? Y/N"
play_again = gets.chomp.upcase
while play_again == "Y"
  new_game = Game.new()
  new_game.play
end

