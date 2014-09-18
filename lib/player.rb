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
    @name = name
    @color = color
    @board = board
  end

  def choose
    begin
      #CHANGE TO ACCEPT A SERIES OF MOVES
    puts "#{color.capitalize} choose a spot to move from (a1 for example)"
    from = gets.chomp.split("")
    from_col = Integer(from[1])
    from_row = Integer(LETTER_MAP[from[0]])
    new_from = [from_col, from_row]

      raise InvalidMoveError if board[new_from].nil?
      raise InvalidTeamError unless board[new_from].color == self.color

      puts "Choose a spot to move to (b2 for example)"
      to = gets.chomp.split("")
      to_col = Integer(to[1])
      to_row = Integer(LETTER_MAP[to[0]])
      new_to = [to_col, to_row]

      [new_from,new_to]

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