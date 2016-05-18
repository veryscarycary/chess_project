require 'byebug'
require "singleton"

class Piece
  attr_accessor :position
  attr_reader :color, :type, :board
  # TODO: include name and a way to convert the name to unicode value
  # posisbly with a hash?

  def initialize(color, position, board, type)
    @color = color
    @position = position
    @board = board
    @type = type
    @selected = false
  end

  WHITE_UNICODE = {:king =>	" \u2654 ",
  :queen =>	" \u2655 ",
  :rook =>	" \u2656 ",
  :bishop =>	" \u2657 ",
  :knight =>	" \u2658 ",
  :pawn =>	" \u2659 "}


  BLACK_UNICODE = {:king =>	" \u265A ",
  :queen =>	" \u265B ",
  :rook =>	" \u265C ",
  :bishop =>	" \u265D ",
  :knight =>	" \u265E ",
  :pawn =>	" \u265F "}

  def to_s
    # debugger
    if @color == :white
      return WHITE_UNICODE[type].encode('utf-8')
    else
      return BLACK_UNICODE[type].encode('utf-8')
    end
  end

  def inspect
    "#{@type}, position: #{@position}"
  end

  def relative_to_actual(relative_moves)
    relative_moves.map do |pos|
      x, y = pos
      a, b = @position
      [x+a, y+b]
    end
  end

  def valid_move?(pos)
    # debugger
    moves(pos).include?(pos)
  end

  def moves(pos)
    []
  end

  private
  def square_available?(end_pos)
    # TODO predict blocking moves(piece in the way)
    board.in_bounds?(end_pos) &&
     (board.empty?(end_pos) || board.enemy_tile?(end_pos, @color))
  end
end

class SlidingPiece < Piece

  def moves(end_pos) # returns array of valid moves
    relative_moves = []

    if @type == :rook || @type == :queen
      (-7..7).each do |tile|
        relative_moves << [0, tile]
        relative_moves << [tile, 0]
      end
    end

    if @type == :bishop || @type == :queen
      (-7..7).count.times do |i|
        7.downto(-7) do |j|
          relative_moves.push([i, j],[j, i], [i, i],[j, j])
        end
      end
    end

    relative_to_actual(relative_moves).select {|move| square_available?(move)}
  end

end

class SteppingPiece < Piece
  def moves(end_pos)
    relative_moves = []

    if @type == :knight
      relative_moves.push([ 2, -1], #
                          [ 2,  1], #
                          [-2, -1], #
                          [-2,  1], #
                          [-1,  2], #
                          [-1, -2], #
                          [ 1,  2], #
                          [ 1, -2]) #
    end

    if @type == :king
      relative_moves.push([ 0,  1],
                          [ 1,  0],
                          [ 0, -1],
                          [-1,  0],
                          [ 1,  1],
                          [ 1, -1],
                          [-1, -1],
                          [-1,  1])
    end

    relative_to_actual(relative_moves).select {|move| square_available?(move)}
  end
end

class Pawn < Piece
  def moves(end_pos)
    relative_moves = []

    if @type == :pawn
      @color == :white ? relative_moves << [-1,0] : relative_moves <<[1,0]
    end

    relative_to_actual(relative_moves).select {|move| square_available?(move)}
  end
end

class NullPiece
attr_accessor :position
attr_reader :color

  def initialize
    @color = nil
  end

  def to_s
    "   "
  end

  def inspect
    "   "
  end
end
