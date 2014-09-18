class HumanPlayer
  LETTER_MAP = {
    'a' => 0,
    'b' => 1,
    'c' => 2,
    'd' => 3,
    'e' => 4,
    'f' => 5,
    'g' => 6,
    'h' => 7,
  }

  attr_reader :name, :color, :board

  def initialize(name, color, board)
    @name, @color, @board =
     name,  color,  board
  end

  def choose

    #CHANGE TO ACCEPT A SERIES OF MOVES
    puts " Enter your series of moves ".colorize(:white).on_light_black
    puts "#{color.capitalize}'s turn".colorize(color).on_black
    begin
      move_series = gets.chomp.split(",")
      if move_series.include?("q")
        raise QuitGame
      end
      raise InvalidInputError if move_series.length < 2
      moves_in_coords = []
      move_series.each do |pos|
        x = Integer(pos[1])
        y = Integer(LETTER_MAP[pos[0]])
        moves_in_coords << [x,y]
      end

      orig_pos = moves_in_coords.first

      raise InvalidMoveError if board[orig_pos].nil?
      raise InvalidTeamError unless board[orig_pos].color == self.color

      moves_in_coords

    rescue InvalidInputError
      puts "Invalid input, please try again"
      retry

    rescue InvalidMoveError
      puts "There's no piece there. Pick a new spot to move from"
      puts
      retry

    rescue InvalidTeamError
      puts "That's not your team. Pick a new piece to move"
      puts
      retry

    end
  end
end

class InvalidTeamError < StandardError
end

class InvalidInputError < StandardError
end