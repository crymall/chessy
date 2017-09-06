require "io/console"

KEYMAP = {
  " " => :space,
  "h" => :left,
  "j" => :down,
  "k" => :up,
  "l" => :right,
  "w" => :up,
  "a" => :left,
  "s" => :down,
  "d" => :right,
  "\t" => :tab,
  "\r" => :return,
  "\n" => :newline,
  "\e" => :escape,
  "\e[A" => :up,
  "\e[B" => :down,
  "\e[C" => :right,
  "\e[D" => :left,
  "\177" => :backspace,
  "\004" => :delete,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0]
}

class Cursor

  attr_reader :cursor_pos, :board, :selected
  attr_accessor :start_pos, :end_pos

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
    @start_pos = []
    @end_pos = []
    @board = board
    @selected = false
  end

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  private

  attr_writer :cursor_pos

  def read_char
    STDIN.echo = false 
    STDIN.raw!
    input = STDIN.getc.chr

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil

      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def handle_key(key)
    case key
    when :return || :space
      puts cursor_pos
    when :left
      update_pos(MOVES[:left])
      return nil
    when :right
      update_pos(MOVES[:right])
      return nil
    when :up
      update_pos(MOVES[:up])
      return nil
    when :down
      update_pos(MOVES[:down])
      return nil
    when :ctrl_c
      Process.exit(0)
    when :space || :return
      @selected = !@selected
      if selected
        @start_pos = cursor_pos
      else
        @end_pos = cursor_pos
        board.move_piece(start_pos, end_pos)
      end
    end
  end

  def update_pos(diff)
    new_pos = [(cursor_pos[0] + diff[0]), (cursor_pos[1] + diff[1])]
    if board.on_board?(new_pos)
      @cursor_pos = new_pos
    end
  end
end
