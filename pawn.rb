require_relative "piece"
require_relative "board"
require_relative "movement"

class Pawn < Piece
  include PawnPiece

  def initialize(position, color, board)
    super(position, color, " ♟ ", board)
  end

end
