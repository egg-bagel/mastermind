class Game

  LETTERS = ["A", "B", "C", "D", "E", "F", "G", "H"]

  def initialize
    @board = Array.new(12) { Array.new(8, "x") }
    @guesses_left = 12
    @code = nil
    @hard_mode = false
    puts "Welcome to my Mastermind game!"
  end

  def play
    puts "To play as the codebreaker, enter 1. To play as the codemaker, enter 2."
    choice = gets.chomp

    if choice == "1"
      play_codebreaker
    elsif choice == "2"
      play_codemaker
    else
      puts "Invalid!"
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

  #================================================================================================
  # CODEBREAKER METHODS
  #================================================================================================

  def play_codebreaker
    @code = LETTERS.sample(4)

    puts "Do you want to play on easy mode or hard mode?"
    puts "Enter 0 for easy mode and 1 for hard mode."
    mode_choice = gets.chomp
    while mode_choice != "0" && mode_choice != "1"
      puts "Invalid input: Please try again: "
      mode_choice = gets.chomp
    end

    if mode_choice.to_i == 0
      @hard_mode = false
    elsif mode_choice.to_i == 1
      @hard_mode = true
    end

    puts "=============================================================================="
    puts "You have 12 turns to try to guess the computer's four-letter code."
    puts "The computer gives you feedback next to your guesses on the board."
    puts "A 2 means that one of your letters is in the code, but you guessed the wrong position."
    puts "A 1 means that one of your letters is in the code, and you guessed the right position."
    puts "A 0 means that you guessed a letter that is not in the code."
    puts "Good luck!"
    puts "=============================================================================="

    while @guesses_left > 0
      guess = make_guess
      write_guess(guess)
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
      puts "The code was #{@code}"
    end
  end

  #Prompts the player to make a guess.
  #If input is valid, writes the guess to the board.
  def make_guess
    puts "Valid choices: A B C D E F G H"
    puts "Enter your 4-letter guess, separating the letters with spaces: "
    guess = gets.chomp.upcase.split(" ")
    while input_error(guess)
      puts "Invalid input! Please try again. Hint: put spaces between the letters."
      puts "Valid choices: R B G Y O V P W"
      puts "Enter your 4-letter guess, separating the letters with spaces: "
      guess = gets.chomp.upcase.split(" ")
    end

    return guess
  end

  def write_guess(guess)
    current_row = @guesses_left - 1
    guess.each_with_index do |letter, index|
      @board[current_row][index] = guess[index]
    end
  end

  #Checks that the user input is valid and the correct length
  def input_error(input)
    if input.length != 4
      return true
    else
      input.each do |item|
        if LETTERS.include?(item)
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

    if @hard_mode == false
      return feedback_array
    else
      return feedback_array.sort
    end
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

  #================================================================================================
  # CODEMAKER METHODS
  #================================================================================================

  def play_codemaker

    puts "Do you want to play on easy mode or hard mode?"
    puts "Enter 0 for easy mode and 1 for hard mode."
    mode_choice = gets.chomp
    while mode_choice != "0" && mode_choice != "1"
      puts "Invalid input: Please try again: "
      mode_choice = gets.chomp
    end

    if mode_choice.to_i == 0
      @hard_mode = false
    elsif mode_choice.to_i == 1
      @hard_mode = true
    end

    puts "=============================================================================="
    puts "The computer has 12 tries to guess a four-letter code of your choosing."
    puts "After each of the computer's guesses, you return feedback on the accuracy of the guess."
    puts "Your feedback must be a list of four integers from 0-2. For example: 0 1 2 2"
    puts "A 2 means that one of the letters is in your code, but the computer guessed the wrong position."
    puts "A 1 means that one of the letters is in your code, and the computer guessed the right position."
    puts "A 0 means that the computer guessed a letter that is not in your code."
    puts "Good luck!"
    puts "=============================================================================="

    @code = set_code
    @letters_available = ["A", "B", "C", "D", "E", "F", "G", "H"]
    @known_letters = []
    @set_letters = []

    while @guesses_left > 0
      guess = get_guess
      write_guess(guess)
      feedback = provide_feedback(guess)
      store_feedback(feedback)
      print_board

      if guess == @code
        puts "You lose! The computer guessed your code."
        break
      end

      @guesses_left -= 1
    end

    if @guesses_left == 0
      puts "You win! The computer ran out of guesses."
    end

  end

  #Prompts the player to set the code for the computer to guess.
  def set_code
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
        if LETTERS.include?(letter)
          next
        else
          return true
        end
      end
    end
    return false
  end

  #Gets a guess from the computer. Returns an array of letters.
  def get_guess
    current_row_index = @guesses_left - 1
    last_row_index = @guesses_left

    if @guesses_left == 12 || @hard_mode == false
      guess = LETTERS.sample(4)

    elsif @guesses_left < 12
      sort_letters(last_row_index)

      guess = Array.new(4, "x")
      guess.each_index do |index|
        if (@board)[last_row_index][index + 4] == 1
          handle_1(guess, index, last_row_index)

        elsif (@board)[last_row_index][index + 4] == 2 
          handle_2(guess, index, last_row_index)

        else (@board)[last_row_index][index + 4] == 0
          handle_0(guess, index, last_row_index)
        end
      end
    end

    return guess
  end

  #Goes through the last guess and allocates letters to @set_letters
  #or deletes them from @letters_available or adds them to @known_letters
  def sort_letters(last_row_index)
    i = 0
    while i < 4
      if @board[last_row_index][i + 4] == 1
        @letters_available.delete(@board[last_row_index][i])
        @known_letters.delete(@board[last_row_index][i])
        unless @set_letters.include?(@board[last_row_index][i])
          @set_letters.push(@board[last_row_index][i])
        end
      elsif @board[last_row_index][i + 4] == 2
        @letters_available.delete(@board[last_row_index][i])
        unless @known_letters.include?(@board[last_row_index][i])
          @known_letters.push(@board[last_row_index][i])
        end
      elsif @board[last_row_index][i + 4] == 0
        @letters_available.delete(@board[last_row_index][i])
      end
      i += 1
    end
  end

  def handle_1(guess, index, last_row_index)
    guess[index] = @board[last_row_index][index]
  end

  def handle_2(guess, index, last_row_index)
    known_letter = @board[last_row_index][index]
    @known_letters.each do |letter|
      unless letter == known_letter || guess.include?(letter)
        guess[index] = letter          
        break
      end
    end
    if guess[index] == "x"
      if @letters_available.length == 0
        guess[index] = known_letter
      else
        new_letter = @letters_available.sample
        while guess.include?(new_letter)
          new_letter = @letters_available.sample
        end
          guess[index] = new_letter
      end
    end
  end

  def handle_0(guess, index, last_row_index)
    if @known_letters.length > 0
      @known_letters.each do |letter|
        unless guess.include?(letter)
          guess[index] = letter
        end
      end
    end
    
    if guess[index] == "x"
      new_random_letter = @letters_available.sample
        while guess.include?(new_random_letter) || @set_letters.include?(new_random_letter)
          new_random_letter = @letters_available.sample
        end
      guess[index] = new_random_letter
    end
  end

  #Prompts the user to return feedback on the computer's guess.
  #Returns an array of integers 0 through 2.
  def provide_feedback(guess)
    puts "The computer guessed #{guess}."
    puts "Now return feedback on how accurate this guess was."
    puts "Enter four integers, 0 through 2, separated by spaces."
    feedback = gets.chomp.split(" ")
    feedback.map! { |x| x.to_i}

    while check_feedback(feedback, guess) == false
      feedback = gets.chomp.split(" ")
      feedback.map! { |x| x.to_i}
    end

    return feedback
  end

  #Checks the player's feedback for validity and accuracy.
  def check_feedback(feedback, guess)
    #First check the validity of the input
    if feedback.length != 4
      puts "Invalid input, please try again: "
      return false
    else
      feedback.each do |num|
        a = [0, 1, 2]
        unless a.include?(num)
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

    if feedback == feedback_verify
      return true
    else
      puts "It looks like your feedback isn't accurate. Please try again: "
      return false
    end

  end

end

play = true
while play == true
  new_game = Game.new
  new_game.play
  puts "Do you want to play again? Enter Y if so: "
  play_again = gets.chomp.upcase
  if play_again == "Y"
    play = true
    next
  else
    play = false
  end 
end