require_relative "board"
require_relative "movement"

class Piece
  include SlidingPiece
  attr_accessor :pos, :board, :moved
  attr_reader :color, :symbol

  def initialize(pos = nil, color = nil, symbol = "   ", board = nil, moved = false)
    @pos = pos
    @color = color
    @symbol = symbol
    @board = board
    @moved = moved
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
    if !self.empty?
      self.moves(start_pos).reject { |pos| move_into_check(start_pos, pos) }
    end
  end

  private

  def move_into_check(start_pos, to_pos)
    dupped = Board.duplicate(self.board)
    dupped.move_piece!(start_pos, to_pos)
    if dupped.in_check?(dupped.turn)
      return true
    end
    false
  end

end
