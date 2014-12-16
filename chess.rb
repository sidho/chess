
class Chess

end


class Board

end


class Piece
  DIAGONALS = [[-1,-1],[-1,1],[1,1],[1,-1]]
  ORTHAGONALS = [[0,-1],[-1,0],[0,1],[1,0]]
  attr_accessor :position, :color, :symbol, :board

  def initialize(position, color, board)
    @position = position
    @color = color
    @board = board
  end

  def moves
  end

end

class SlidingPiece < Piece

  def moves(directions)
    valid_end_positions = []
    directions.each do |delta|
      cur_pos = position
      valid = true
      while valid
        prev_pos = cur_pos
        cur_pos = prev_pos.map { |(x,y)| x + delta[0], y + delta[1] }
        if cur_pos
          valid = false
        else
          valid_end_positions << cur_pos
        end
      end
    end
    valid_end_positions
  end
  
end

class Queen < SlidingPiece
  def initialize(position, color, board)
    super
    @symbol = "Q"
  end

  def moves
    super DIAGONALS + ORTHAGONALS
  end

end

class Rook < SlidingPiece
  def initialize(position, color, board)
    super
    @symbol = "R"
  end

  def moves
    super ORTHAGONALS
  end

end

class Bishop < SlidingPiece
  def initialize(position, color, board)
    super
    @symbol = "B"
  end

  def moves
    super DIAGONALS
  end

end

class SteppingPiece < Piece

  def moves(directions)
  end
end

class King < SteppingPiece
  def initialize(position, color, board)
    super
    @symbol = "K"
  end
end

class Knight < SteppingPiece
  def initialize(position, color, board)
    super
    @symbol = "H"
  end
end

class Pawn < SteppingPiece
  def initialize(position, color, board)
    super
    @symbol = "P"
  end
end
