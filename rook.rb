class Rook < SlidingPiece
  def initialize(position, color, board)
    super
    @symbol = (color == :black ? "\u265C" : "\u2656")
  end

  def moves
    super ORTHOGONALS
  end
end
