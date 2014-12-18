class King < SteppingPiece
  def initialize(position, color, board)
    super
    @symbol = "\u265A"
  end

  def moves
    super DIAGONALS + ORTHOGONALS
  end
end
