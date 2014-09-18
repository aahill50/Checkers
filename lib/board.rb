require_relative 'piece'
require 'colorize'

class Board
  attr_accessor :rows

  def initialize(rows = Array.new(8) {Array.new(8)})
    @rows = rows
    set_up
  end

  def [](pos)
    x,y = pos[0], pos[1]
    self.rows[x][y]

  end

  def []=(pos, piece)
    x,y = pos[0], pos[1]
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
    when 6 then self[pos] = Piece.new(self, false, pos, :light_red)
    when 7 then self[pos] = Piece.new(self, false, pos, :light_red)
    end
  end

  def pieces
    self.rows.flatten.compact
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

  def show_board
    self.rows.each_with_index do |row, row_index|
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
          print "   ".colorize(:default).on_light_red
        end
      end
      puts
    end
  end
end

b = Board.new
b.show_board
b.pieces.each {|piece| p piece}