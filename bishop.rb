require_relative "piece"
require_relative "board"
require_relative "movement"

class Bishop < Piece
  include SlidingPiece

  def initialize(position, color, board)
    super(position, color, " ♝ ", board)
  end

end
