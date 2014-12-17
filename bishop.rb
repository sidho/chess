class Bishop < SlidingPiece
  def initialize(position, color, board)
    super
    @symbol = (color == :black ? "\u265D" : "\u2657")
  end

  def moves
    super DIAGONALS
  end
end
