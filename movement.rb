module SlidingPiece
  HORIZONTAL = [[-1, 0], [0, -1], [0, 1], [1, 0]]
  DIAGONAL = [[-1, -1], [-1, 1], [1, -1], [1, 1]]

  def moves(start_pos)
    if self.is_a?(Bishop)
      diagonal_dirs(start_pos)
    elsif self.is_a?(Rook)
      horizontal_dirs(start_pos)
    else
      diagonal_dirs(start_pos) + horizontal_dirs(start_pos)
    end
  end

  def horizontal_dirs(start_pos)
    grow_unblocked_moves_in_dir(HORIZONTAL, start_pos)
  end

  def diagonal_dirs(start_pos)
    grow_unblocked_moves_in_dir(DIAGONAL, start_pos)
  end

  def grow_unblocked_moves_in_dir(dirs, start_pos)
    result = []

    dirs.each do |dir|
      test_move = [(start_pos[0] + dir[0]), (start_pos[1] + dir[1])]

      while test_move.first.between?(0, 7) && test_move.last.between?(0, 7)
        if self.board[test_move].color == self.color
          break
        elsif self.board[test_move].is_a?(NullPiece)
          result.push(test_move)
          test_move = [(test_move[0] + dir[0]), (test_move[1] + dir[1])]
        elsif self.board[test_move].color != self.color
          result.push(test_move)
          break
        end
      end
    end

    result
  end
end

module PawnPiece

  def moves(start_pos)
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

    if next_move[0].between?(0, 7) && next_move[1].between?(0, 7)
      if self.board[next_move].is_a?(NullPiece)
        result << next_move
      end

      if self.moved == false
        new_move = [(next_move[0] + dir_arr[0]), (next_move[1] + dir_arr[1])]
        on_board = new_move[0].between?(0, 7) && new_move[1].between?(0, 7)

        if self.board[new_move].is_a?(NullPiece)
          result << new_move
        end

      end
    end

    result
  end

  def diagonal_dirs(start_pos)
    if self.color == :white
      dirs = [[-1, 1], [-1, -1]]
    else
      dirs = [[1, 1], [1, -1]]
    end

    result = []

    dirs.each do |dir|
      diag_move = [self.pos[0] + dir[0], self.pos[1] + dir[1]]
      on_board = diag_move[0].between?(0, 7) && diag_move[1].between?(0, 7)

      if on_board &&
        (self.board[diag_move].color != self.color) &&
        !self.board[diag_move].is_a?(NullPiece)
          result << diag_move
      end
    end

    result
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
