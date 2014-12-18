class HumanPlayer
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def opposing_color
    color == :white ? :black : :white
  end

  def play_turn
    puts "Select start position: (ex: A5)"
    start_pos = get_coordinate
    puts "Select end position (ex: B4)"
    end_pos = get_coordinate
    [start_pos, end_pos]
  end

  def get_coordinate
    letters = %w(A B C D E F G H)
    pos = gets.chomp.split('')
    unless (pos[1].to_i != 0 && pos[1].to_i <= 8) &&
            letters.include?(pos[0].upcase)
      raise ArgumentError.new "Invalid input entry."
    end
    [8 - pos[1].to_i, letters.index(pos[0].upcase)]
  end
end
