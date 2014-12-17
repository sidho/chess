class King < SteppingPiece
  def initialize(position, color, board)
    super
    @symbol = (color == :black ? "\u265A" : "\u2654")
  end

  def moves
    super DIAGONALS + ORTHOGONALS
  end
end
