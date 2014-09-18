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
    begin
      #CHANGE TO ACCEPT A SERIES OF MOVES
      puts "#{color.capitalize} enter a series of moves"
      move_series = gets.chomp.split(",")
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