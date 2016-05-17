require "singleton"

class Piece
  attr_accessor :color, :position, :board
  # TODO: include name and a way to convert the name to unicode value
  # posisbly with a hash?

  def initialize(color, position, board)
    @color = color
    @position = position
    @board = board
  end

  def valid_move?(end_pos)
    true
  end

  def to_s
    " X "
  end

  def inspect
    " X "
  end
end

class SlidingPiece < Piece

  def initialize(color, position, direction)
    super(color, position)
    @direction = direction #=> [:straight, :diagonal]
  end

  def moves(end_pos) # returns array of valid moves
    relative_moves = []

    if @direction.include?(:straight)
      (-7..7).each do |tile|
        relative_moves << [0, tile]
        relative_moves << [tile, 0]
      end
    end

    if @direction.include?(:diagonal)
      (-7..7).count.times do |i|
        7.downto(-7) do |j|
          relative_moves.push([i, j],[j, i], [i, i],[j, j])
        end
      end
    end

    relative_to_actual(relative_moves).select {|move| move.valid_move?(move)}

  end

  def relative_to_actual(relative_moves)
    all_moves = relative_moves.map do |pos|
      x, y = pos
      a, b = @current_pos
      [x+a, y+b]
    end
  end

  def valid_move?(end_pos)
    board.in_bounds?(pos)

  end



end

class SteppingPiece < Piece
  def moves(start_pos, end_pos)
  end
end

class Pawn < Piece
  def moves(start_pos, end_pos)
  end
end

class NullPiece

  def initialize
  end

  def to_s
    "   "
  end

  def inspect
    "   "
  end
end
