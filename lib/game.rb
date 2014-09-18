require_relative 'board.rb'
require_relative 'piece.rb'
require_relative 'player.rb'

class Checkers
  attr_reader :board, :players, :current_player

  def initialize(board = Board.new, player1, player2)
    @board = board
    @players = [player1, player2]
    @current_player = players.first
  end

  def play
    board.show_board

    until board.winner
      player_choice = current_player.choose
      next unless board.move_piece(player_choice) #Will not switch turn if false

      switch_turn
      board.show_board
    end

    puts "#{board.winner.capitalize} team won!"

  rescue QuitGame
    puts "Thanks for playing!"
    exit
  end


def switch_turn
  @current_player = (@current_player == players[0]) ? players[1] : players[0]
end
end

class QuitGame < StandardError
end
b= Board.new
p1 = HumanPlayer.new("Player A", :white, b)
p2 =  HumanPlayer.new("Player B", :red, b)
game = Checkers.new(b, p1, p2)
game.play