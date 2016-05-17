class Player
  def initialize(name = "Tyrion", board, display)
    @name = name
    @display = display
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
