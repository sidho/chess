class Pawn < Piece
  attr_accessor :has_moved

  def initialize(position, color, board)
    super
    @symbol = "\u265F"
    @has_moved = false
  end

  def color_direction
    self.color == :black ? 1 : -1
  end

  def pawn_capture(pos)
    valid_end_positions = []
    capture_moves = [[1*color_direction,-1],[1*color_direction,1]]

    #Can move 1 space diagonally forward, if that would capture an opposing piece.
    capture_moves.each do |delta|
      target_position = [pos[0] + delta[0], pos[1] + delta[1]]
      if (in_bounds?(target_position) && board[target_position] &&
          board[target_position].color == self.opposing_color)
        #space is occupied by an enemy AND
        #space is in bounds
        valid_end_positions << target_position
      end
    end
    valid_end_positions
  end

  def pawn_forward(pos)
    valid_end_positions = []
    [1, 2].each do |i|
      #Can move 1 space forward, if that space is empty.
      target_position = [pos[0] + (i * color_direction), pos[1]]
      unless !in_bounds?(target_position) || board[target_position]
        valid_end_positions << target_position
      end
      #If the first fails, we know the next won't be valid either.
      return valid_end_positions if valid_end_positions.empty? || has_moved
    end
    valid_end_positions
  end

  def moves
    valid_end_positions = []
    cur_pos = self.position

    valid_end_positions += pawn_capture(cur_pos)
    valid_end_positions += pawn_forward(cur_pos)

    valid_end_positions
  end
end
