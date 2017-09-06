module SlidingPiece

  def moves(start_pos)
    move_dirs(start_pos)
  end

  def move_dirs(start_pos)
    if self.is_a?(Bishop)
      diagonal_dirs(start_pos)
    elsif self.is_a?(Rook)
      horizontal_dirs(start_pos)
    else
      diagonal_dirs(start_pos) + horizontal_dirs(start_pos)
    end
  end

  def horizontal_dirs(start_pos)
    hsh = { up: [-1, 0], right: [0, 1], down: [1, 0], left: [0, -1] }
    grow_unblocked_moves_in_dir(hsh)
  end

  def diagonal_dirs(start_pos)
    hsh = { upright: [-1, 1], upleft: [-1, -1], downright: [1, 1], downleft: [1, -1] }
    grow_unblocked_moves_in_dir(hsh)
  end

  def grow_unblocked_moves_in_dir(dirs_hash)
    result = []

    dirs_hash.each do |_, v|
      dir_moves = [[v[0] + self.pos[0], v[1] + self.pos[1]]]

      while true
        on_board = dir_moves.last[0].between?(0, 7) && dir_moves.last[1].between?(0, 7)
        if on_board
          radar = detect_space(dir_moves.last)
        end

        if !on_board || radar == :friend
          dir_moves.pop
          result += dir_moves
          break
        elsif radar == :foe
          result += dir_moves
          break
        end

        next_move = [v[0] + dir_moves.last[0], v[1] + dir_moves.last[1]]
        dir_moves << next_move
      end
    end

    result
  end


  def detect_space(pos)
    if self.board[pos].is_a?(NullPiece)
      :empty
    elsif self.board[pos].color == self.color
      :friend
    else
      :foe
    end
  end

end

module PawnPiece

  def moves(start_pos)
    move_dirs(start_pos)
  end

  def move_dirs(start_pos)
    diagonal_dirs(start_pos) + horizontal_dirs(start_pos)
  end

  def horizontal_dirs(start_pos)
    if self.color == :white
      dir_arr = [-1, 0]
    else
      dir_arr = [1, 0]
    end

    result = []

    next_move = [(self.pos[0] + dir_arr[0]), (self.pos[1] + dir_arr[1])]

    on_board = next_move[0].between?(0, 7) && next_move[1].between?(0, 7)

    if on_board
      if detect_space(next_move) == :empty
        result << next_move
      end

      if self.moved == false
        new_move = [(next_move[0] + dir_arr[0]), (next_move[1] + dir_arr[1])]
        on_board = new_move[0].between?(0, 7) && new_move[1].between?(0, 7)

        if on_board && detect_space(new_move) == :empty
          result << new_move
        end

      end
    end

    result
  end

  def diagonal_dirs(start_pos)
    if self.color == :white
      hsh = { upright: [-1, 1], upleft: [-1, -1] }
    else
      hsh = { downright: [1, 1], downleft: [1, -1] }
    end

    result = []

    hsh.each do |_, v|
      diag_move = [v[0] + self.pos[0], v[1] + self.pos[1]]
      on_board = diag_move[0].between?(0, 7) && diag_move[1].between?(0, 7)

      if on_board && detect_space(diag_move) == :foe
        result << diag_move
      end
    end

    result
  end

  def detect_space(pos)
    if self.board[pos].is_a?(NullPiece)
      return :empty
    elsif self.board[pos].color == self.color
      return :friend
    else
      return :foe
    end
  end


end


module SteppingPiece

  def moves(start_pos)
    answer = []

    move_diffs.each_value do |v|
      possible_move = [(start_pos[0] + v[0]), (start_pos[1] + v[1])]
      if possible_move.all? { |el| el.between?(0, 7) }
        answer << possible_move
      end
    end

    answer.reject { |moves| same_side?(moves) }
  end

  def same_side?(end_pos)
    self.board[end_pos].color == self.color
  end

  private

  def move_diffs
    if self.is_a?(King)
      {
        up: [-1, 0],
        right: [0, 1],
        down: [1, 0],
        left: [0, -1],
        upright: [-1, 1],
        upleft: [-1, -1],
        downright: [1, 1],
        downleft: [1, -1]
      }
    else
      {
        upright: [-2, 1],
        rightup: [-1, 2],
        rightdown: [1, 2],
        downright: [2, 1],
        downleft: [2, -1],
        leftdown: [-2, 1],
        leftup: [-1, -2],
        upleft: [-2, -1]
      }
    end
  end

end
