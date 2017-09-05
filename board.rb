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

  def on_board?(pos)
    pos.all? { |n| n.between?(0, 7) }
  end

  def dup
    copy = Board.new

    self.board.each_with_index do |el, row|
      el.each_with_index do |space, col|
        copy.board[row][col] = space
        copy.board[row][col].board = copy
        copy.board[row][col].pos = [row, col]
      end
    end

    copy.turn = self.turn

    copy
  end

  def in_check?(color)
    king_pos = nil

    self.board.each_with_index do |el, row|
      el.each_with_index do |space, col|
        if space.is_a?(King) && space.color == color
          king_pos = [row, col]
        end
      end
    end

    self.board.each_with_index do |el, row|
      el.each_with_index do |space, col|
        if !space.is_a?(NullPiece) &&
           space.color != color &&
           space.moves([row, col]).include?(king_pos)
              if valid_move?([row, col], king_pos)
                return true
              end
        end
      end
    end

    false
  end

  def checkmate?(color)
    king_pos = nil

    self.board.each_with_index do |el, row|
      el.each_with_index do |space, col|
        if space.is_a?(King) && space.color == color
          king_pos = [row, col]
        end
      end
    end

    x = king_pos[0]
    y = king_pos[1]

    if in_check?(color)
      debugger
      if self.board[x][y].valid_moves([x, y]).length == 0
        return true
      end
    end

    false
  end


  def move_piece(start_pos, end_pos)
    self[start_pos].display_board(self)

    if valid_move?(start_pos, end_pos)
      self[end_pos] = self[start_pos]
      self[start_pos] = NullPiece.instance
      self[end_pos].pos = end_pos
      self[end_pos].moved = true
      self.switch_turn
    end
  end

  def move_piece!(start_pos, end_pos)
    self[start_pos].display_board(self)
    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.instance
    self[end_pos].pos = end_pos
    self[end_pos].moved = true
    self.switch_turn
  end

  def switch_turn
    if @turn == :white
      @turn = :black
    else
      @turn = :white
    end
  end

  def valid_move?(start_pos, end_pos)
    if self[start_pos].is_a?(NullPiece)
      puts "No piece found."
      sleep(0.75)
      return false
    elsif self[start_pos].color != self.turn
      puts "Not your piece."
      sleep(0.75)
      return false
    elsif start_pos == end_pos
      puts "Can't move to the same space."
      sleep(0.75)
      return false
    elsif !self[start_pos].valid_moves(start_pos).include?(end_pos)
      puts "Invalid move."
      sleep(0.75)
      return false
    end

    true
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @board[row][col] = value
  end

  def other_turn
    if self.turn == :white
      return :black
    else
      return :white
    end
  end

end
