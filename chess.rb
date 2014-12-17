
class Chess

end


class Board

  ROOKS = [[0,0], [0,7], [7,0], [7,7]]
  KNIGHTS = [[0,1], [0,6], [7,1], [7,6]]
  BISHOPS = [[0,2], [0,5], [7,2], [7,5]]

  attr_accessor :grid

  def initialize (empty = false)
    @grid = Array.new(8) { Array.new(8) }
    setup_board unless empty
  end

  def setup_board
    ROOKS.each do |rook|
      if rook[0] > 3
        self[rook] = Rook.new(rook, :white, self)
      else
        self[rook] = Rook.new(rook, :black, self)
      end
    end

    KNIGHTS.each do |knight|
      if knight[0] > 3
        self[knight] = Knight.new(knight, :white, self)
      else
        self[knight] = Knight.new(knight, :black, self)
      end
    end

    BISHOPS.each do |bishop|
      if bishop[0] > 3
        self[bishop] = Bishop.new(bishop, :white, self)
      else
        self[bishop] = Bishop.new(bishop, :black, self)
      end
    end

    (0..7).each do |col|
      self[[6, col]] = Pawn.new([6,col], :white, self)
      self[[1, col]] = Pawn.new([1,col], :black, self)
    end

    self[[7, 3]] = Queen.new([7,3], :white, self)
    self[[0, 3]] = Queen.new([0,3], :black, self)

    self[[7, 4]] = King.new([7,4], :white, self)
    self[[0, 4]] = King.new([0,4], :black, self)
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  def in_check?(color)
    all_opponents = @grid.flatten.compact.select {|p| p.opposing_color == color}
    king_pos = find_king(color)
    all_opponents.any? {|p| p.moves.include?(king_pos)}
  end

  def find_king(color)
    all_allies = @grid.flatten.compact.select { |p| p.color == color}
    king = all_allies.find { |p| p.class == King }
    king.position
  end

  def dup
    board_copy = Board.new(true)
    @grid.each_with_index do |row, r|
      row.each_with_index do |piece, c|
        pos = piece.position.dup
        color = piece.color
        board_copy[r][c] = piece.class.new(pos, color, board_copy) if piece
      end
    end
    board_copy
  end

  def move(start, end_pos)
    raise "No piece at starting position." unless self[start]
    raise "Invalid ending position." unless self[start].moves.include?(end_pos)
    self[end_pos] = self[start]
    self[end_pos].position = end_pos
    self[end_pos].has_moved = true if self[end_pos].is_a? Pawn
    self[start] = nil
  end

  def render
    # print "__"; (0..7).each {|i| print "|#{i} "} puts
    puts "   0  1  2  3  4  5  6  7 "
    @grid.each_with_index do |row, row_idx|
      row_string = "#{row_idx} "
      row.each do |piece|
        row_string += "|__" unless piece
        row_string += "|#{piece.render} " if piece
      end
      puts row_string + "|"
    end
    true
  end

end


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

  def moves
  end

  def moves_into_check?(pos)
    board_copy = @board.dup
    board_copy.move(position, pos)
    board_copy.in_check?(color)
  end

  def inspect
    "#{color} #{symbol} at #{position}"
  end

  def render
    "#{symbol}"
  end

end

class SlidingPiece < Piece

  def moves(directions)
    valid_end_positions = []
    directions.each do |delta|
      cur_pos = position
      valid = true
      while valid
        prev_pos = cur_pos
        cur_pos = [prev_pos[0] + delta[0], prev_pos[1] + delta[1]]
      #  cur_pos = prev_pos.map { |coordinate| [coordinate[0] + delta[0], coordinate[1] + delta[1]] }
        if (!in_bounds?(cur_pos) ||
            (board[cur_pos] && board[cur_pos].color == self.color) ||
            (board[prev_pos] && board[prev_pos].color == self.opposing_color))
          #space is occupied by and ally OR
          #space is blocked by an enemy in the previous square OR
          #space is out of bounds
          valid = false
        else
          valid_end_positions << cur_pos
        end
      end
    end
    valid_end_positions
  end

end

class Queen < SlidingPiece
  def initialize(position, color, board)
    super
    @symbol = (color == :black ? "\u265B" : "\u2655")
  end

  def moves
    super DIAGONALS + ORTHOGONALS
  end

end

class Rook < SlidingPiece
  def initialize(position, color, board)
    super
    @symbol = (color == :black ? "\u265C" : "\u2656")
  end

  def moves
    super ORTHOGONALS
  end

end

class Bishop < SlidingPiece
  def initialize(position, color, board)
    super
    @symbol = (color == :black ? "\u265D" : "\u2657")
  end

  def moves
    super DIAGONALS
end

end

class SteppingPiece < Piece

  def moves(directions)
    valid_end_positions = []
    cur_pos = self.position
    directions.each do |delta|
      target_position = [cur_pos[0] + delta[0], cur_pos[1] + delta[1]]
      unless (!in_bounds?(target_position) ||
              (board[target_position] &&
               board[target_position].color == self.color))
        #space is occupied by an ally OR
        #space is out of bounds
        valid_end_positions << target_position
      end
    end
    valid_end_positions
  end

end

class King < SteppingPiece
  def initialize(position, color, board)
    super
    @symbol = (color == :black ? "\u265A" : "\u2654")
  end

  def moves
    super DIAGONALS + ORTHOGONALS
  end

end

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

class Pawn < Piece

  attr_accessor :has_moved

  def initialize(position, color, board)
    super
    @symbol = (color == :black ? "\u265F" : "\u2659")
    @has_moved = false
  end

  def color_direction
    self.color == :black ? 1 : -1
  end

  def pawn_capture(pos)
    valid_end_positions = []
    capture_moves = [[1*color_direction,-1],[1*color_direction,1]]

    #Can move 1 space diagonally forward, if that would capture an opposing piece.
    capture_moves.each do |delta|
      target_position = [pos[0] + delta[0], pos[1] + delta[1]]
      if (in_bounds?(target_position) && board[target_position] &&
          board[target_position].color == self.opposing_color)
        #space is occupied by an enemy AND
        #space is in bounds
        valid_end_positions << target_position
      end
    end
    valid_end_positions
  end

  def pawn_forward(pos)
    valid_end_positions = []
    [1,2].each do |i|
      #Can move 1 space forward, if that space is empty.
      target_position = [pos[0] + (i * color_direction), pos[1]]
      unless !in_bounds?(target_position) || board[target_position]
        valid_end_positions << target_position
      end
      #If the first fails, we know the next won't be valid either.
      return valid_end_positions if valid_end_positions.empty? || has_moved
    end
    valid_end_positions
  end

  def moves
    valid_end_positions = []
    cur_pos = self.position

    valid_end_positions += pawn_capture(cur_pos)
    valid_end_positions += pawn_forward(cur_pos)

    valid_end_positions
  end

end
