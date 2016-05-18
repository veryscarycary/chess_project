require 'byebug'
class Board
  attr_accessor :grid, :selected

  def initialize(grid)
    @grid = grid
    @selected = nil
  end

  def handle_selection(pos)
    if empty?(pos) && @selected.nil?
      # no response
    else
      @selected.nil? ? @selected = pos : move_piece(pos)
    end
  end

  def move_piece(end_pos)
    start_pos = @selected
    piece = self[start_pos]
    if piece.valid_move?(end_pos) && not_blocked?(end_pos)
      attack(start_pos, end_pos)
      # self[start_pos].position = end_pos
      # self[end_pos].position = start_pos
      # self[start_pos], self[end_pos] = self[end_pos], self[start_pos]
    end
    @selected = nil
  end

  def not_blocked?(end_pos)
    # debugger
    row1, col1 = end_pos
    row2, col2 = @selected
    row_range = (row2..row1).to_a
    col_range = (col2..col1).to_a
    return true unless self[@selected].is_a?(SlidingPiece)
    return true if row_range.count == 1 && col_range.count == 1

    x_diff = row1 - row2
    y_diff = col1 - col2

    if x_diff != 0 && y_diff == 0 # Moving up/down in same col
      ([row1, row2].min...[row1, row2].max).each do |row|
        next if [row, col1] == @selected
        return false unless self[[row, col1]].is_a?(NullPiece)
      end
    elsif y_diff != 0 && x_diff == 0 # Moving left/right in same row
      ([col1, col2].min...[col1, col2].max).each do |col|
        next if [row1, col] == @selected
        return false unless self[[row1, col]].is_a?(NullPiece)
      end
    else #diagonal
      cols = ([col1, col2].min...[col1, col2].max).to_a
      rows = ([row1, row2].min...[row1, row2].max).to_a
      cols = cols.reverse if y_diff < 0
      rows = rows.reverse if x_diff < 0

      return true if rows.count == 0 || cols.count == 0

      rows.count.times do |i|
        next if [rows[i], cols[i]] == @selected
        return false unless self[[rows[i], cols[i]]].is_a?(NullPiece)
      end

    end

    true
  end




    # if row_range.count > 1 && col_range.count == 1
    #   row_range.each do |row|
    #     return false unless self[[row, col_range.first]].is_a?(NullPiece)
    #   end
    # elsif col_range.count > 1 && row_range.count == 1
    #   col_range.each do |col|
    #     return false unless self[[row_range.first, col]].is_a?(NullPiece)
    #   end
    # else
    #   row_range.each_with_index do |row, i|
    #     return false unless self[[row, col_range[i]]].is_a?(NullPiece)
    #   end
    # end
    # difference = [(row2-row1).abs, (col2-col1).abs]
    # difference[0].times do |row|
      # unless self[[[row1, row2].min + row, [col1, col2].min +
      #    difference[1]]].is_a?(NullPiece)
      #    true

  #   true
  # end

  def attack(start_pos, end_pos)
    unless self[end_pos].color == self[start_pos].color
      self[start_pos].position = end_pos
      self[end_pos].position = start_pos
      self[end_pos] = NullPiece.new unless self[end_pos].is_a?(NullPiece)
      self[end_pos], self[start_pos] = self[start_pos], self[end_pos]
    end
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

  def empty?(pos)
    self[pos].is_a?(NullPiece)
  end

  def enemy_tile?(pos, color)
    self[pos].color != color
  end

  def in_bounds?(pos)
    x, y = pos
    x.between?(0, 7) && y.between?(0, 7)
  end

  def setup_pieces
    @grid.each_with_index do |row, row_num|
      row.each_with_index do |square, col_num|
          if row_num.between?(0, 1)
            @grid[row_num][col_num] = get_type(:black, [row_num, col_num], self)
            # @grid[row_num][col_num] = Piece.new(:black, [row_num, col_num], self, get_type([row_num, col_num]))
          elsif row_num.between?(2, 5)
            @grid[row_num][col_num] = NullPiece.new
          else
            @grid[row_num][col_num] = get_type(:white, [row_num, col_num], self)
            # @grid[row_num][col_num] = Piece.new(:white, [row_num, col_num], self, get_type([row_num, col_num]))
          end
      end
    end
  end

  def get_type(color, pos, board)
    x, y = pos

    rooks = [[0,0],[0,7], [7,7], [7,0]]
      type = :rook if rooks.include?(pos)
    knights = [[0,1], [0,6], [7,1], [7,6]]
      type = :knight if knights.include?(pos)
    bishops = [[0,2], [0,5], [7,2], [7,5]]
      type = :bishop if bishops.include?(pos)
    queens = [[0,3], [7,3]]
      type = :queen if queens.include?(pos)
    kings = [[0,4], [7,4]]
      type = :king if kings.include?(pos)
      type = :pawn if x == 1 || x == 6
      type = :nil if x.between?(2, 5)

    if type == :rook || type == :queen || type == :bishop
      SlidingPiece.new(color, pos, board, type)
    elsif type == :knight || type == :king
      SteppingPiece.new(color, pos, board, type)
    else
      Pawn.new(color, pos, board, type)
    end
  end

  def self.default_grid
    board = Array.new(2) { Array.new(8) {} }
    board.concat(Array.new(4) {Array.new(8) {} })
    board.concat(Array.new(2) {Array.new(8) {} })
  end

  class IllegalMoveError < StandardError
    attr_reader :message, :object

    def initialize(message, board)
      @message = message
      @board = board
    end
  end

end
