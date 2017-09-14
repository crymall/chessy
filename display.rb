require_relative "cursor"
require_relative "board"
require "colorize"


class Display

  attr_accessor :board, :cursor

  def initialize(board)
    @cursor = Cursor.new([0,0], board)
    @board = board
  end

  def render
    system("clear")
    white_bg = false

    board.board.each_with_index do |row, y|
      white_bg = !white_bg

      row.each_with_index do |space, x|
        white_bg = !white_bg
        bg = white_bg ? :red : :blue
        bg = :yellow if cursor.cursor_pos == [y,x]
        piece_color = space.color == :black ? :black : :white
        piece_color = :green if cursor.selected == true && cursor.cursor_pos == [y,x]

        print space.symbol.colorize(:color => piece_color, :background => bg)

      end
      puts " "
    end

    print "#{self.board.turn.capitalize} to play."
  end

  def play

    until self.board.checkmate?(self.board.turn)
      render
      puts " "
      cursor.get_input
    end

    if self.board.turn == :white
      puts "Checkmate!"
      puts "Black wins!"
    else
      puts "Checkmate!"
      puts "White wins!"
    end
  end

end

b = Display.new(Board.new)
b.play
