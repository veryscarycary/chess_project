class Piece
  attr_accessor :color

  def initialize(color)
    @color = color
  end

  def valid_move?(end_pos)
    true
  end

  def to_s
    "X"
  end

  def inspect
    "X"
  end
end
