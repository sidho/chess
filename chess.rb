require_relative 'board'
require_relative 'piece'
require_relative 'sliding_piece'
require_relative 'stepping_piece'
require_relative 'rook'
require_relative 'bishop'
require_relative 'queen'
require_relative 'knight'
require_relative 'king'
require_relative 'pawn'
require_relative 'human_player'
require 'io/console'
# $stdin.getch

#system("clear")

class Chess
  attr_accessor :board, :players

  def initialize()
    @board = Board.new
    @players = [HumanPlayer.new(:white), HumanPlayer.new(:black)]
    play
  end

  def play
    turn_number = 0
    until won?(players[0]) || won?(players[1])
      process_turn(turn_number)
      turn_number = (turn_number == 0 ? 1 : 0)
    end
    board.render
    puts "#{winner.color.to_s.capitalize} won! Congratulations!"
    true
  end

  def process_turn(turn_number)
    board.render
    begin
      start, end_coord = players[turn_number].play_turn
      board.move(start, end_coord, players[turn_number].color)
    rescue ArgumentError => e
      puts "#{e.message} Input a new choice:"
      retry
    end
  end

  def won?(player)
    @board.checkmate?(player.opposing_color)
  end

  def winner
    #we only call this if someone's won, so binary logic should work here.
    won?(players[0]) ? players[0] : players[1]
  end
end

p = Chess.new
