class SlidingPiece < Piece
  def moves(directions)
    valid_end_positions = []
    directions.each do |delta|
      cur_pos = position
      valid = true
      while valid
        prev_pos = cur_pos
        cur_pos = [prev_pos[0] + delta[0], prev_pos[1] + delta[1]]
      #  cur_pos = prev_pos.map { |coordinate| [coordinate[0] + delta[0], coordinate[1] + delta[1]] }
        if (!in_bounds?(cur_pos) ||
            (board[cur_pos] && board[cur_pos].color == self.color) ||
            (board[prev_pos] && board[prev_pos].color == self.opposing_color))
          #space is occupied by and ally OR
          #space is blocked by an enemy in the previous square OR
          #space is out of bounds
          valid = false
        else
          valid_end_positions << cur_pos
        end
      end
    end
    valid_end_positions
  end
end
