require_relative "cursor"
require_relative "board"
require 'colorize'
require "byebug"


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
      print "#{y} "
      row.each_with_index do |space, x|
        white_bg = !white_bg
        bg = white_bg ? :white : :brown
        bg = :yellow if cursor.cursor_pos == [y,x]
        piece_color = space.color == :black ? :black : :red
        piece_color = :green if cursor.selected == true && cursor.cursor_pos == [y,x]

        print space.symbol.colorize(:color => piece_color, :background => bg)

      end
      puts " "
    end

    print "   0  1  2  3  4  5  6  7 "
  end

  def test_play
    # debugger
    count = 0
    while count < 1000
      render
        puts " "
      cursor.get_input
      count += 1
    end
  end

end

b = Display.new(Board.new)
b.test_play
