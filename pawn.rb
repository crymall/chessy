require_relative "piece"
require_relative "board"

class Pawn < Piece

  def initialize(position, color)
    super(position, color, " ♟ ")
  end

end
