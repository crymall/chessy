require_relative "piece"
require_relative "board"
require_relative "movement"

class Queen < Piece
  include SlidingPiece

  def initialize(position, color)
    super(position, color, " ♛ ")
  end

end
