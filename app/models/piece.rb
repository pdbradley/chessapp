require 'pry'
class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :moves

  self.inheritance_column = :piece_type

  scope :kings,   -> { where(piece_type: 'King') }
  scope :queens,  -> { where(piece_type: 'Queen') }
  scope :rooks,   -> { where(piece_type: 'Rook') }
  scope :bishops, -> { where(piece_type: 'Bishop') }
  scope :knights, -> { where(piece_type: 'Knight') }
  scope :pawns,   -> { where(piece_type: 'Pawn') }

  # VALID_MOVE METHOD

  def my_turn?
    true
    # true if it is my turn in the game
  end

  def not_occupied_by_me?(destination_x, destination_y)
    # is there a piece at this place of the same color as self
    game.pieces.where(piece_color: self.piece_color, current_position_x: destination_x, current_position_y: destination_y).empty?
  end

  def on_the_board?(destination_x, destination_y)
    destination_x.between?(0, 7) && destination_y.between?(0, 7)
  end

  def is_move_possible?(destination_x, destination_y)
    is_move_blocked(destination_x, destination_y) == false
  end

  def valid_move?(destination_x, destination_y)
    my_turn? &&
    not_occupied_by_me?(destination_x, destination_y) &&
    on_the_board?(destination_x, destination_y) &&
    is_move_possible?(destination_x, destination_y)
  end

  # MOVE_BLOCKED METHODS

  def is_horizontal_move_blocked(destination_x)    
    destination_x > self.current_position_x ? dir_x = 1 : dir_x = -1
    (1..((destination_x - dir_x) - self.current_position_x ).abs).each do |i|
      x = self.current_position_x + i * dir_x
      return true if Piece.find_by(current_position_x: x, current_position_y: self.current_position_y)
    end
    false
  end

  def is_vertical_move_blocked(destination_y)
    destination_y > self.current_position_y ? dir_y = 1 : dir_y = -1
    (1..((destination_y - dir_y) - self.current_position_y).abs).each do |i|
      y = self.current_position_y + i * dir_y
      return true if Piece.find_by(current_position_x: self.current_position_x, current_position_y: y)
    end
    false
  end

  def is_diagonal_move_blocked(destination_x, destination_y)
    destination_x > self.current_position_x ? dir_x = 1 : dir_x = -1
    destination_y > self.current_position_y ? dir_y = 1 : dir_y = -1
    (1..((destination_x - dir_x) - self.current_position_x).abs).each do |i|
      x = self.current_position_x + i * dir_x
      y = self.current_position_y + i * dir_y
      return true if Piece.find_by(current_position_x: x, current_position_y: y)
    end
    false
  end

  def is_move_blocked(destination_x, destination_y)
    if self.current_position_y == destination_y
      return is_horizontal_move_blocked(destination_x)
    elsif self.current_position_x == destination_x
      return is_vertical_move_blocked(destination_y)
    else
      return is_diagonal_move_blocked(destination_x, destination_y)
    end
  end

end
