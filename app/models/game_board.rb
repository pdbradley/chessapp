class GameBoard
  attr_accessor :board

  def initialize
    rank = ('a'..'h').to_a
    file = (1..8).to_a.reverse
    @board = []

    file.each do |f|
      rank.each do |r|
        @board << r + f.to_s
      end
    end
  end

  def self.all_spaces
    result = Array.new
    (0..7).each do |x|
      (0..7).each do |y|
        result << [x,y]
      end
    end
    result
  end

  def self.make_board(game)
    puts "Make board"
    make_rook(game)
    make_knight(game)
    make_bishop(game)
    make_queen(game)
    make_king(game)
    make_pawn(game)
  end

  def self.make_rook(game)
    [{ x: 0, y: 0 }, { x: 7, y: 0 }].each do |position|
      p = Piece.create!(piece_type: "Rook", piece_color: "white", 
        current_x: position[:x], current_y: position[:y], 
        user_id: game.white_player_id, game_id: game.id)
    end

    [{ x: 0, y: 7 }, { x: 7, y: 7 }].each do |position|
      Piece.create(piece_type: "Rook", piece_color: "black", 
        current_x: position[:x], current_y: position[:y],
        user_id: game.black_player_id, game_id: game.id)
    end
  end

  def self.make_knight(game)
    [{ x: 1, y: 0 }, { x: 6, y: 0 }].each do |position|
      Piece.create(piece_type: "Knight", piece_color: "white", 
        current_x: position[:x], current_y: position[:y], 
        user_id: game.white_player_id, game_id: game.id)
    end

    [{ x: 1, y: 7 }, { x: 6, y: 7 }].each do |position|
      Piece.create(piece_type: "Knight", piece_color: "black", 
        current_x: position[:x], current_y: position[:y],
        user_id: game.black_player_id, game_id: game.id)
    end
  end

  def self.make_bishop(game)
    [{ x: 2, y: 0 }, { x: 5, y: 0 }].each do |position|
      Piece.create(piece_type: "Bishop", piece_color: "white", 
        current_x: position[:x], current_y: position[:y], 
        user_id: game.white_player_id, game_id: game.id)
    end

    [{ x: 2, y: 7 }, { x: 5, y: 7 }].each do |position|
      Piece.create(piece_type: "Bishop", piece_color: "black", 
        current_x: position[:x], current_y: position[:y],
        user_id: game.black_player_id, game_id: game.id)
    end
  end

  def self.make_queen(game)
    Piece.create(piece_type: "Queen", piece_color: "white", 
      current_x: 3, current_y: 0, 
      user_id: game.white_player_id, game_id: game.id)

    Piece.create(piece_type: "Queen", piece_color: "black", 
      current_x: 3, current_y: 7,
      user_id: game.black_player_id, game_id: game.id)
  end

  def self.make_king(game)
    Piece.create(piece_type: "King", piece_color: "white", 
      current_x: 4, current_y: 0, 
      user_id: game.white_player_id, game_id: game.id)

    Piece.create(piece_type: "King", piece_color: "black", 
      current_x: 4, current_y: 7,
      user_id: game.black_player_id, game_id: game.id)
  end

  def self.make_pawn(game)

    (0..7).each do |x|
      Piece.create(piece_type: "Pawn", piece_color: "white", 
        current_x: x, current_y: 1, 
        user_id: game.white_player_id, game_id: game.id)
    end

    (0..7).each do |x|
      Piece.create(piece_type: "Pawn", piece_color: "black", 
        current_x: x, current_y: 6, 
        user_id: game.black_player_id, game_id: game.id)
    end
  end
end


