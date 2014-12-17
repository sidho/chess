class SteppingPiece < Piece
  def moves(directions)
    valid_end_positions = []
    cur_pos = self.position
    directions.each do |delta|
      target_position = [cur_pos[0] + delta[0], cur_pos[1] + delta[1]]
      unless (!in_bounds?(target_position) ||
              (board[target_position] &&
               board[target_position].color == self.color))
        #space is occupied by an ally OR
        #space is out of bounds
        valid_end_positions << target_position
      end
    end
    valid_end_positions
  end
end
