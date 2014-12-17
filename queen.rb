class Queen < SlidingPiece
  def initialize(position, color, board)
    super
    @symbol = (color == :black ? "\u265B" : "\u2655")
  end

  def moves
    super DIAGONALS + ORTHOGONALS
  end
end
