class Player
  def initialize(name = "Tyrion", board)
    @name = name
    @display = Display.new(board, self)
  end

  def move
    result = nil
    until result
      @display.render
      result = @display.get_input
    end
    result
  end
end
