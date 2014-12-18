class Rook < SlidingPiece
  def initialize(position, color, board)
    super
    @symbol = "\u265C"
  end

  def moves
    super ORTHOGONALS
  end
end
