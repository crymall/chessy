require_relative "piece"
require_relative "cursor"
require_relative "nullpiece"
require_relative "rook"
require_relative "knight"
require_relative "bishop"
require_relative "queen"
require_relative "king"
require_relative "pawn"


class Board

  attr_accessor :board, :turn

  def initialize
    @board = self.populate(Array.new(8) { Array.new })
    @turn = :white
  end

  def populate(arr)
    arr[0] = [
      Rook.new( [0, 0], :black, self),
      Knight.new( [0, 1], :black, self),
      Bishop.new( [0, 2], :black, self ),
      Queen.new( [0, 3], :black, self ),
      King.new( [0, 4], :black, self ),
      Bishop.new( [0, 5], :black, self ),
      Knight.new( [0, 6], :black, self ),
      Rook.new( [0, 7], :black, self )
    ]

    8.times { |n| arr[1] << Pawn.new([1, n], :black, self) }

    arr[2..5].each { |row| 8.times { row << NullPiece.instance } }

    8.times { |n| arr[6] << Pawn.new([6, n], :white, self) }

    arr[7] = [
      Rook.new( [7, 0], :white, self ),
      Knight.new( [7, 1], :white, self ),
      Bishop.new( [7, 2], :white, self ),
      Queen.new( [7, 4], :white, self ),
      King.new( [7, 3], :white, self ),
      Bishop.new([ 7, 5], :white, self ),
      Knight.new( [7, 6], :white, self ),
      Rook.new( [7, 7], :white, self )
    ]

    arr
  end

  def move_piece(start_pos, end_pos)
    self[start_pos].display_board(self)

    if !self[start_pos].is_a?(NullPiece) &&
       self[start_pos].valid_moves(start_pos).include?(end_pos)
      self[end_pos] = self[start_pos]
      self[start_pos] = NullPiece.instance
      self[end_pos].pos = end_pos
      self[end_pos].moved = true
      self.switch_turn
    else
      puts "Invalid move."
      sleep(0.5)
    end
  end

  def move_piece!(start_pos, end_pos)
    self[start_pos].display_board(self)

    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.instance
    self[end_pos].pos = end_pos
    self[end_pos].moved = true
  end

  def in_check?(color)
    king_pos = []

    self.board.each_with_index do |el, row|
      el.each_with_index do |space, col|
        if space.is_a?(King) && space.color == color
          king_pos += [row, col]
        end
      end
    end

    self.board.each_with_index do |el, row|
      el.each_with_index do |space, col|
        if !space.is_a?(NullPiece) &&
           space.color != color &&
           space.moves([row, col]).include?(king_pos)
              return true
        end
      end
    end

    false

  end

  def checkmate?(color)

    if in_check?(color)
      self.board.each_with_index do |el, row|
        el.each_with_index do |space, col|
          if !space.is_a?(NullPiece) &&
             space.color == color &&
             !space.valid_moves([row, col]).empty?
                return false
          end
        end
      end

      return true
    end

    false
  end

  def on_board?(pos)
    pos.all? { |n| n.between?(0, 7) }
  end

  def switch_turn
    if @turn == :white
      @turn = :black
    else
      @turn = :white
    end
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @board[row][col] = value
  end

  def self.duplicate(board)
    copy = Board.new

    board.board.each_with_index do |el, row|
      el.each_with_index do |space, col|
        if space.is_a?(NullPiece)
          copy.board[row][col] = NullPiece.instance
        elsif space.is_a?(Pawn)
          copy.board[row][col] = Pawn.new([row, col], space.color, copy)
        elsif space.is_a?(Rook)
          copy.board[row][col] = Rook.new([row, col], space.color, copy)
        elsif space.is_a?(Knight)
          copy.board[row][col] = Knight.new([row, col], space.color, copy)
        elsif space.is_a?(Bishop)
          copy.board[row][col] = Bishop.new([row, col], space.color, copy)
        elsif space.is_a?(Queen)
          copy.board[row][col] = Queen.new([row, col], space.color, copy)
        elsif space.is_a?(King)
          copy.board[row][col] = King.new([row, col], space.color, copy)
        end
      end
    end

    copy.turn = board.turn

    copy
  end

end
