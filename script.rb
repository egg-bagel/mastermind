class Game

  COLOR_CHOICES = ["R", "G", "B", "Y", "O", "P", "V", "W"]

  def initialize
    @board = Array.new(12) { Array.new(8, "x") }
    @code = COLOR_CHOICES.sample(4)
    @guesses_left = 12
  end

  attr_accessor :code

  #To play, I need to:
  #1) Get a guess from the user, repeating the question if input is incorrect.
  #2) Store that guess in @board[@guesses_left - 12][0..3]
  #3) Take the guess and compare it to the computer's code.
  #4) Return an array of 2s, 1s, and 0s reflecting the accuracy of the guess.
  #5) Take the feedback array and store it in @board[@guesses_left - 12][4..7]
  #6) Print the board and all its current content
  def play

    guess = get_guess
    feedback = compare_guess(guess)
    store_feedback(feedback)

    print_board

    @guesses_left -= 1
  end

  def get_guess
    puts "Color choices R B G Y O V P W. Enter your 4-color guess with letters separated by spaces: "
    guess = gets.chomp.split(" ")
    i = 0
    while i <= 3
      @board[@guesses_left - 12][i] = guess[i]
      i += 1
    end
    return guess
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
    current_row = @guesses_left - 12
    i = 0
    while i <= 3
      @board[current_row][i + 4] = feedback_array[i]
      i += 1
    end
  end

  def draw_row(row)
    print "+---+---+---+---+---+---+---+---+\n"
    i = 7
    while i >= 0
      print "| #{row[i]} "
      i -= 1
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
