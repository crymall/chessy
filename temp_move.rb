def grow_unblocked_moves_in_dir(dirs_hash)
  result = []
  dirs_hash.each do |_, v|
    dir_moves = [[v[0] + self.pos[0], v[1] + self.pos[1]]]
    # if first_move.first.between?(0,7) && first_move.last.between?(0,7)
    #   dir_moves << first_move
    # else
    #   next
    # end
    while true
      unless dir_moves.last[0].between?(0,7) && dir_moves.last[1].between?(0,7)
        dir_moves.pop
        result += dir_moves
        break
      end
      next_move = [v[0] + dir_moves.last[0], v[1] + dir_moves.last[1]]
      dir_moves << next_move
      end
    end
  end
  result
end
