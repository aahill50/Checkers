require_relative 'piece'
require 'colorize'

class Board
  attr_accessor :rows

  def initialize(rows = Array.new(8) {Array.new(8)})
    @rows = rows
    set_up
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
    when 0 then self[pos] = Piece.new(self, false, pos, :white)
    when 1 then self[pos] = Piece.new(self, false, pos, :white)
    when 2 then self[pos] = Piece.new(self, false, pos, :white)
    when 5 then self[pos] = Piece.new(self, false, pos, :red)
    when 6 then self[pos] = Piece.new(self, false, pos, :red)
    when 7 then self[pos] = Piece.new(self, false, pos, :red)
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

  def move_piece(from, to)
    return true if self[from].perform_slide(to)
    self[from].perform_jump(to)
  rescue InvalidMoveError
    puts "You can't move like that"
    return false
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
            print " #{self[square].render} ".colorize(color).on_black
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
    puts
  end
end

class InvalidMoveError < StandardError
end

# b = Board.new
# system('clear')
# b.show_board
# b.pieces.each {|piece| p piece, piece.moves}