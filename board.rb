require 'colorize'
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

  def all_pieces(color = nil)
    return @grid.flatten.compact unless color
    @grid.flatten.compact.select { |p| p.color == color}
  end

  def in_check?(color)
    all_opponents = all_pieces.select {|p| p.opposing_color == color}
    king_pos = find_king(color)
    all_opponents.any? {|p| p.moves.include?(king_pos)}
  end

  def find_king(color)
    all_allies = all_pieces(color)
    king = all_allies.find { |p| p.class == King }
    king.position
  end

  def checkmate?(color)
    if in_check?(color)
      all_allies = all_pieces(color)
      all_allies.any? { |p| !p.valid_moves.empty? } ? false : true
    else
      false
    end
  end

  def dup
    board_copy = Board.new(true)
    all_pieces.each do |piece|
      pos = piece.position.dup
      color = piece.color
      board_copy[pos] = piece.class.new(pos, color, board_copy)
    end
    board_copy
  end

  def move(start, end_pos, color)
    raise ArgumentError.new "No piece at starting position." unless self[start]
    valid_moves = self[start].valid_moves
    raise ArgumentError.new "Invalid ending position." unless valid_moves.include?(end_pos)
    if self[start].opposing_color == color
      raise ArgumentError.new "Can't move opponent's piece, scumbag!"
    end
    self[start].has_moved = true if self[start].is_a? Pawn
    move!(start, end_pos)
  end

  def move!(start, end_pos)
    self[end_pos] = self[start]
    self[end_pos].position = end_pos
    self[start] = nil
  end

  def toggle_colorize(color)
    color == :black ? :light_white : :black
  end

  def render
    # print "__"; (0..7).each {|i| print "|#{i} "} puts
    letters = %w(A B C D E F G H)
    colorize = :light_white
    #puts "   1  2  3  4  5  6  7  8 "
    puts "   A  B  C  D  E  F  G  H "
    @grid.each_with_index do |row, row_idx|
      row_string = "#{8 - row_idx} "
      row.each do |piece|
        tile_string = "   " unless piece
        tile_string = " #{piece.render} " if piece
        row_string += tile_string.colorize(:background => colorize)
        colorize = toggle_colorize(colorize)
      end
      colorize = toggle_colorize(colorize)
      puts row_string + " "
    end
    true
  end

end
