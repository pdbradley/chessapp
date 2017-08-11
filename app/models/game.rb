class Game < ApplicationRecord
  belongs_to :white_player, class_name: 'User', optional: true
  belongs_to :black_player, class_name: 'User', optional: true

  GAME_STATUS = [:open, :in_progress, :white_wins, :black_wins, :draw, :stalemate, :white_check, :black_check]

  has_many :pieces
  has_many :moves
  has_one :game_board

  scope :available, -> { where(game_status: :open) }

  after_create :set_game_board

  validates :white_player, presence: true, allow_blank: true
  validates :black_player, presence: true, allow_blank: true
  validates :game_status, presence: true

  def turn_change
    self.turn == "white" ? self.turn = "black" : self.turn = "white"
  end

  def stalemate?
    return false if check

    king = Piece.find_by(game_id: self.id, piece_type: "King", piece_color: self.turn)
    king_x = king.current_x
    king_y = king.current_y
    (-1..1).each do |x|
      (-1..1).each  do |y|
        test_x = king_x + x
        test_y = king_y + y
        if king.valid_move?(test_x,test_y)
          return false unless enemy_can_attack?(test_x,test_y)
        end
      end
    end
    true
  end


  def enemy_can_attack?(x,y)
    Piece.where(game_id: self.id, piece_color: opposite_color).each do |piece|
      return true if piece.valid_move?(x, y)
    end
    false
  end

  def opposite_color
    self.turn == "white" ? "black" : "white"
  end

  def check
    king = Piece.find_by(game_id: self.id, piece_type: "King", piece_color: self.turn)
    opposite_color = self.opposite_color

    Piece.where(game_id: self.id, piece_color: opposite_color).each do |piece|
        return true if piece.valid_move?(king.current_x, king.current_y)
    end
    false
  end

  def king_taken_next_move?
    #whose turn is it
    if turn == 'white'
      player = white_player
    else
      player = black_player
    end

    # find the king's position in the opposite color
    opposing_king = Piece.find_by(game_id: self.id, piece_type: "King", piece_color: self.opposite_color)
    opposing_king_location = [opposing_king.current_x, opposing_king.current_y]

    # find the possible moves for that color
    player_pieces = game.pieces.where(piece_color: self.turn)
    player_pieces.each do |piece|
      if piece.possible_moves.include? opposing_king_location
        return true
      end
    end

    # if kings' position is in possible moves return true
    return false
  end



  # def checkmate?
  #   # whose move is it?
  #   # for every move black can make....
  #     # for every move that white can THEN make
  #       # if the king's position is in any list of possible moves, checkmate

  #   # 
    
  # end

  private
  def set_game_board
    GameBoard.make_board(self)
  end
end 
