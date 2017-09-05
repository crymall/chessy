require_relative "piece"
require_relative "cursor"
require_relative "nullpiece"
require_relative "rook"
require_relative "knight"
require_relative "bishop"
require_relative "queen"
require_relative "king"
require_relative "pawn"

require 'byebug'


class Board

  attr_accessor :board

  def initialize
    @board = self.populate(Array.new(8) { Array.new })
  end

  def populate(arr)
    arr[0] = [
      Rook.new([0,0], :black),
      Knight.new([0,1], :black),
      Bishop.new([0,2], :black),
      Queen.new([0,3], :black),
      King.new([0,4], :black),
      Bishop.new([0,5], :black),
      Knight.new([0,6], :black),
      Rook.new([0,7], :black)
    ]
    8.times { |n| arr[1] << Pawn.new([1, n], :black) }

    arr[2..5].each do |row|
      8.times { |n| row << NullPiece.instance }
    end

    8.times { |n| arr[6] << Pawn.new([6, n], :white) }

    arr[7] = [
      Rook.new([7,0], :white),
      Knight.new([7,1], :white),
      Bishop.new([7,2], :white),
      King.new([7,3], :white),
      Queen.new([7,4], :white),
      Bishop.new([7,5], :white),
      Knight.new([7,6], :white),
      Rook.new([7,7], :white)
    ]
    arr
  end

  def move_piece(start_pos, end_pos)
    # self[start_pos].display_board(board)
    self[start_pos].display_board(self)
    if valid_move?(start_pos, end_pos)
      unless self[end_pos] == self[start_pos] || !self[start_pos].moves(start_pos).include?(end_pos)
        self[end_pos] = self[start_pos]
        self[start_pos] = NullPiece.instance
      end
    end
  end

  def valid_move?(start_pos, end_pos)
    # debugger
    unless on_board?(end_pos) && on_board?(start_pos)
      raise ArgumentError.new("Please enter a position that is ON the board.")
    end
    unless self[start_pos].is_a?(Piece)
      raise ArgumentError.new("No piece found in starting position.")
    end
    # unless self[end_pos].nil?
    #   raise ArgumentError.new("This position is occupied.")
    # end
    true
  end

  def on_board?(pos)
    pos.all? { |n| n.between?(0,7) }
  end


  def [](pos)
    row, col = pos
    board[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @board[row][col] = value
  end

end

# b = Board.new
# b.move_piece([0, 3], [4, 4])
# p b
