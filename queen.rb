class Queen < SlidingPiece
  def initialize(position, color, board)
    super
    @symbol = "\u265B"
  end

  def moves
    super DIAGONALS + ORTHOGONALS
  end
end
