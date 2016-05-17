
class Display
  include Cursorable

  def initialize(board, player)
    @board = board
    @player = player
    @cursor_pos = [0, 0]
  end

  def build_grid
    @board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :light_blue
    elsif (i + j).odd?
      bg = :light_black
      fg = @board.get_color([i, j])
    else
      bg = :yellow
      fg = @board.get_color([i, j])
    end
    { background: bg, color: fg}
  end

  def render
    system("clear")
    puts "Arrow keys, WASD, or vim to move, space or enter to confirm."
    build_grid.each { |row| puts row.join }
  end

end
