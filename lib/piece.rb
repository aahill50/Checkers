require_relative 'board.rb'
require 'colorize'

class Piece
  MOVE_DIRS_WHITE = [[1,1], [1,-1]] #default for white, flip y's for red
  MOVE_DIRS_RED = [[-1,1], [-1,-1]]

  attr_reader :color, :board
  attr_accessor :pos, :is_king

  def initialize(pos, color, board = Board.new, is_king = false)
    @pos, @color, @board, @is_king =
     pos,  color, board,  is_king

  end

  def is_king?
    self.is_king
  end

  def perform_slide(pos)
    raise InvalidMoveError unless board[pos].nil?
    return false unless dist(pos) == 1

    raise InvalidMoveError unless self.moves.include?(pos)

    self.board[self.pos], self.board[pos] = nil, self
    self.pos = pos
    true
  end

  def perform_jump(pos)
    raise InvalidMoveError unless dist(pos) == 2
    raise InvalidMoveError unless self.moves.include?(pos)

    jumped_pos = calc_jumped_pos(self.pos, pos)
    self.board[self.pos], self.board[pos] = nil, self
    self.board[jumped_pos] = nil
    self.pos = pos

    true
  end

  def perform_move(pos)
    case dist(pos)
    when 1 then perform_slide(pos)
    when 2 then perform_jump(pos)
    else
      raise InvalidMoveError
    end
  end

  def perform_move!(pos)
    self.board[self.pos], self.board[pos] = nil, self
    self.pos = pos

    if dist(pos) == 2
      self.board[jumped_pos] = nil
      jumped_pos = calc_jumped_pos(self.pos, pos)
    end

    true
  end

  def move_dirs
    case self.color
    when :white
      MOVE_DIRS_WHITE
    when :red
      MOVE_DIRS_RED
    end
  end

  def dist(pos)
    new_x, new_y = pos
    curr_x, curr_y = self.pos

    diff_x = curr_x - new_x
    diff_y = curr_y - new_y
    return false unless diff_x.abs == diff_y.abs

    diff_x.abs
 end

 def calc_jumped_pos(orig_pos, new_pos)
   orig_x, orig_y = orig_pos
   new_x, new_y = new_pos

   jumped_x = (orig_x + new_x) / 2
   jumped_y = (orig_y + new_y) / 2

   [jumped_x, jumped_y]
 end

  def moves
    move_array = []

    self.move_dirs.each do |(dx,dy)|
      self_x = self.pos[0]
      self_y = self.pos[1]
      new_pos_1 = [self_x + dx, self_y + dy]
      new_pos_2 = [self_x + dx * 2, self_y + dy * 2]   #Adds jump positions

      if board.empty?(new_pos_1)
        move_array += [new_pos_1]
      elsif board[new_pos_1].color != self.color && board.empty?(new_pos_2)
        move_array +=  [new_pos_2]
      end
    end

    move_array.select {|(x,y)| x.between?(0,7) && y.between?(0,7)}
  end

  def should_promote?

  end

  def promote
    self.is_king = true
  end

  def render
    color = (self.color == :white) ? :white : :red
    "o".colorize(color)
  end

  def inspect
    "#{self.color} - #{self.pos}"
  end
end

class InvalidJumpError < StandardError
end