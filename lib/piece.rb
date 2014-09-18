require_relative 'board.rb'
require 'colorize'

class Piece
  MOVE_DIRS = [[1,1], [1,-1]]

  attr_reader :is_king, :color, :pos

  def initialize(board = Board.new, is_king = false, pos, color)
    @is_king = is_king
    @pos = pos
    @color = color
  end

  def is_king?
    self.is_king
  end

  def perform_slide

  end

  def perform_jump

  end

  def move_diffs
    case self.color
    when :white
      #FINISH WRITING
    end

  end

  def should_promote?

  end

  def promote
    self.is_king = true
  end

  def render
    color = (self.color == :white) ? :white : :red
    "O".colorize(color)
  end

  def inspect
    "#{self.color} - #{self.pos}"
  end
end
