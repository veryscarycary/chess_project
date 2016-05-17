

class Board
  attr_accessor :grid
  def initialize(grid)
    @grid = grid
  end

  def move(start_pos, end_pos)
    unless start_pos.is_a?(Piece) && Piece.valid_move?(end_pos)
      raise IllegalMoveError.new("Not a valid move", self)
    end

    update_piece_pos(start_pos, end_pos)
  end

  def update_piece_pos(start_pos, end_pos)
    piece = self[start_pos]
    self[start_pos] = nil
    self[end_pos] = piece
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def get_color(pos)
    self[pos].is_a?(Piece) ? self[pos].color : :black
  end

  def rows
    @grid
  end

  def in_bounds?(pos)
    x, y = pos
    x.between?(0, 7) && y.between?(0, 7)
  end

  def self.default_grid
    board = Array.new(2) { Array.new(8) {[Piece.new(:black)]}}
    board.concat(Array.new(4) {Array.new(8) {[nil]}})
    board.concat(Array.new(2) {Array.new(8) {[Piece.new(:white)]}})
  end

  class IllegalMoveError < StandardError
    attr_reader :message, :object

    def initialize(message, board)
      @message = message
      @board = board
    end
  end

end

# board = Board.new(Board.default_grid)
# display = Display.new(board, "Trion")
# display.render
