require_relative "board"
require_relative "movement"

class Piece
  include SlidingPiece
  attr_accessor :pos, :board
  attr_reader :color, :symbol

  def initialize(pos = nil, color = nil, symbol = "   ", board = nil)
    @pos = pos
    @color = color
    @symbol = symbol
    @board = board
  end

  def empty?
    self.is_a?(NullPiece)
  end

  def display_board(current_board)
    @board = current_board
  end

  def to_s
    symbol
  end

  def valid_moves(start_pos)
    self.moves(start_pos)
  end

  private

  def move_into_check(to_pos)

  end

end
