class Piece
  DIAGONALS = [[-1,-1],[-1,1],[1,1],[1,-1]]
  ORTHOGONALS = [[0,-1],[-1,0],[0,1],[1,0]]

  attr_accessor :position, :color, :symbol, :board

  def initialize(position, color, board)
    @position = position
    @color = color
    @board = board
  end

  def opposing_color
    color == :white ? :black : :white
  end

  def in_bounds?(pos)
    row, col = pos
    (row >= 0 && row <= 7 && col >= 0 && col <= 7)
  end

  def valid_moves
    self.moves.select { |move| !moves_into_check?(move) }
  end

  def moves
  end

  def moves_into_check?(pos)
    board_copy = @board.dup
    board_copy.move!(position, pos)
    board_copy.in_check?(color)
  end

  def inspect
    "#{color} #{symbol} at #{position}"
  end

  def render
    "#{symbol}"
  end

end
