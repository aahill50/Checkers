require_relative 'piece'
require 'colorize'

class Board
  attr_accessor :rows

  def initialize(primary_board = true)
    @rows = Array.new(8) {Array.new(8)}
    set_up if primary_board
  end

  def [](pos)
    x,y = pos
    self.rows[x][y]
  end

  def []=(pos, piece)
    x,y = pos
    self.rows[x][y] = piece
  end

  def set_up
    legal_squares.each do |(x,y)|
      create_piece(x,y)
    end
  end

  def create_piece(x,y)
    pos = [x,y]
    case x
    when (0..2) then self[pos] = Piece.new(pos, :white, self)
    when (5..7) then self[pos] = Piece.new(pos, :red, self)
    end
  end

  def legal_squares
    legal_squares = []
    self.rows.each_with_index do |row, row_index|
      row.each_index do |col_index|
        square = [row_index, col_index]
        legal_squares << square if is_legal?(square)
      end
    end

    legal_squares
  end

  def is_legal?(coord)
    x,y = coord[0], coord[1]

    x % 2 != y % 2 #Checks to see if indicies are not both even or both odd
  end

  def empty?(pos)
    self[pos].nil?
  end

  def occupied?(pos)
    !empty?(pos)
  end

  def winner
    return :white if all_pieces.all? {|piece| piece.color == :white}
    return :red if all_pieces.all? {|piece| piece.color == :red}
    nil
  end

  def move_piece(move_sequence)
    raise InvalidMoveError unless is_valid_move?(move_sequence)

    move_sequence.each_cons(2) do |move_pair|
      move1, move2 = move_pair
      self[move1].perform_move(move2)
    end

    true
  rescue InvalidMoveError
    puts "You can't move like that"
    return false
  end


  def is_valid_move?(move_sequence)
    duped_board = self.dup

    move_sequence.each_cons(2) do |(move1, move2)|
      return false if duped_board.empty?(move1)
      return false unless duped_board[move1].moves.include?(move2)
      chain_move = move1 != move_sequence.first
      duped_board[move1].perform_move!(move2, chain_move)
    end
    true
  end

  def all_pieces
    self.rows.flatten.compact
  end

  def show_board
    system('clear')

    print "  ".colorize(:light_black).on_light_white
    ('A'..'H').each do |num|
      print " #{num} ".colorize(:light_black).on_light_white
    end

    print "  ".colorize(:light_black).on_light_white
    puts

    self.rows.each_with_index do |row, row_index|
      print "#{row_index} ".colorize(:light_black).on_light_white

      row.each_with_index do |square, col_index|
        square = [row_index, col_index]

        if legal_squares.include?(square)
          if self[square].nil?
            print "   ".colorize(:default).on_black
          else
            color = self[square].color
            print "#{self[square].render}".colorize(color).on_black
          end

        else
          print "   ".colorize(:default).on_red
        end

        if col_index == 7
          print " #{row_index}".colorize(:light_black).on_light_white
        end
      end
      puts
    end

    print "  ".colorize(:light_black).on_light_white
    ('A'..'H').each do |num|
      print " #{num} ".colorize(:light_black).on_light_white
    end

    print "  ".colorize(:light_black).on_light_white
    puts
    puts "       Type q to quit       ".colorize(:white).on_black
  end

  def dup
    new_board = Board.new(false)

    self.all_pieces.each do |piece|
      new_board[piece.pos] = Piece.new(piece.pos, piece.color, new_board, piece.is_king)
    end

    new_board
  end
end

class Array
  def deep_dup
    map{ |el| (el.is_a?(Array) ? el.deep_dup : el)}
  end
end

class InvalidMoveError < StandardError
end

# b = Board.new
# system('clear')
# b.show_board
# b.pieces.each {|piece| p piece, piece.moves}
