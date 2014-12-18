class Bishop < SlidingPiece
  def initialize(position, color, board)
    super
    @symbol = "\u265D"
  end

  def moves
    super DIAGONALS
  end
end
