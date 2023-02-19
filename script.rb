class Game

  LETTER_CHOICES = ["A", "B", "C", "D", "E", "F", "G", "H"]

  def initialize
    @board = Array.new(12) { Array.new(8, "x") }
    @code = LETTER_CHOICES.sample(4)
    @guesses_left = 12
    puts "Welcome to my Mastermind game!"
    puts "You have 12 turns to try to guess the computer's four-letter code."
    puts "The computer gives you feedback next to your guesses on the board."
    puts "A 2 means that one of your letters is in the code, but you guessed the wrong position."
    puts "A 1 means that one of your letters is in the code, and you guessed the right position."
    puts "A 0 means that you guessed a letter that is not in the code."
    puts "Good luck!"
  end

  def play

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

  def get_guess
    puts "Valid choices: A B C D E F G H"
    puts "Enter your 4-letter guess, separating the letters with spaces: "
    #guess = guess.split(" ")
    guess = gets.chomp.split(" ")
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
    return feedback_array.sort
  end

  def store_feedback(feedback_array)
    current_row = @guesses_left - 1
    i = 0
    while i <= 3
      @board[current_row][i + 4] = feedback_array[i]
      i += 1
    end
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

  def print_board
    current_board = @board
    current_board.each do |row|
      draw_row(row)
      print "\n"
    end
    print "+---+---+---+---+---+---+---+---+\n"
  end

end

test = Game.new()
test.play
puts "Do you want to play again? Y/N"
play_again = gets.chomp
while play_again == "Y" || play_again == "y"
  new_game = Game.new()
  new_game.play
end

