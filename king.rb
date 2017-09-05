require_relative "piece"
require_relative "board"
require_relative "movement"

class King < Piece
  include SteppingPiece

  def initialize(position, color, board)
    super(position, color, " ♚ ", board)
  end

end
