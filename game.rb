require_relative "board"
require_relative "pieces"
require_relative "player"
require_relative "display"

class Game

  def initialize(board = Board.new(Board.default_grid))
    # board ||= Board.new.default_grid
    @board = board
    @player1 = Player.new("Dude1", board)
    @player2 = Player.new("Dude2", board)
    @display = Display.new(board, @player1)
    @current_player = @player1
  end

  def run
    until game_over?
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
