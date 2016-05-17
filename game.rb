require 'byebug'
require_relative "pieces"
require_relative "board"
require_relative "cursorable"
require_relative "display"
require_relative "player"

class Game
  attr_reader :board

  def initialize(board = Board.new(Board.default_grid))
    # board ||= Board.new.default_grid
    @board = board
    @board.setup_pieces
    @display = Display.new(board, @player1)
    @player1 = Player.new("Dude1", board, @display)
    @player2 = Player.new("Dude2", board, @display)
    @current_player = @player1
  end

  def run
    until game_over?
      # debugger
      @current_player.move
    end
  end

  def game_over?
    false
  end
end

if __FILE__ == $PROGRAM_NAME
g = Game.new

g.run
# board = Board.new(Board.default_grid)
# display = Display.new(board, "Trion")
# display.render
end
