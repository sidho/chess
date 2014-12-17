class Knight < SteppingPiece
  KNIGHTS_MOVES = [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]
  ]

  def initialize(position, color, board)
    super
    @symbol = (color == :black ? "\u265E" : "\u2658")
  end

  def moves
    super KNIGHTS_MOVES
  end
end
