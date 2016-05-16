require_relative "board.rb"
class Game

  def initialize(board = Board.new(Board.default_grid))
    # board ||= Board.new.default_grid
    @board = board
    @player1 = Player.new("Dude1", board)
    @player2 = Player.new("Dude2", board)
    @display = Display.new(board)
  end

  def run
    until game_over?
      player.move
    end
  end

  def game_over?
    false
  end
end
