# Chess board
class Board
  attr_accessor :square_hash

  LETTERS = ('a'..'h').to_a
  NUMBERS = (1..8).to_a
  LETTERS_HASH = { 1 => 'a', 2 => 'b', 3 => 'c', 4 => 'd', 5 => 'e', 6 => 'f', 7 => 'g', 8 => 'h' }.freeze
  def initialize
    @square_hash = {}
    @history = History.new
  end

  def create
    LETTERS.each_with_index do |letter, index|
      NUMBERS.each do |n|
        @square_hash["#{letter}#{n}"] = Square.new(index + 1, n, "#{letter}#{n}")
      end
    end
  end

  def store_board
    @history.snapshot.push(simplified_board)
  end

  def store_move(from_square, to_square)
    @history.last_move = {}
    @history.last_move[from_square.piece_type.to_s] = [from_square, to_square]
  end
end

# One square of the chess board
class Square
  attr_accessor :piece_on_square, :x, :y, :coordinates

  def initialize(x_axis, y_axis, coordinates, piece_on_square = nil)
    @piece_on_square = piece_on_square
    @x = x_axis
    @y = y_axis
    @coordinates = coordinates
  end
end

# A piece of the game
class Piece
  attr_accessor :color, :unicode, :position

  def initialize(color, position = nil)
    @color = color
    @position = position
  end
end

# The knight
class Knight < Piece
  attr_accessor :on_initial_square, :color, :valid_children

  def initialize(color, position = nil)
    super(color)
    @position = position
    case @color
    when 'black'
      @unicode = '\u2658'
    when 'white'
      @unicode = '\u265E'
    end
  end

  def self.get_valid_moves(from_square, to_square)
    potentials = []
    potentials.push(
      [from_square.x + 2, from_square.y + 1],
      [from_square.x + 2, from_square.y - 1],
      [from_square.x + 1, from_square.y + 2],
      [from_square.x + 1, from_square.y - 2],
      [from_square.x - 2, from_square.y + 1],
      [from_square.x - 2, from_square.y - 1], 
      [from_square.x - 1, from_square.y + 2], 
      [from_square.x - 1, from_square.y - 2]
    )

    valid_children = potentials.select { |i| i[0].between?(0, 8) && i[1].between?(0,8) }
    valid_children.include? [to_square.x, to_square.y]
  end
end

# History of all moves and board
class History
  attr_accessor :snapshot, :last_move

  def initialize
    @snapshot = []
    @last_move = {}
  end
end

board = Board.new
board.create
p board
