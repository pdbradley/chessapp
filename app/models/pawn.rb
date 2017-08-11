class Pawn < Piece
  # PAWNS MOVE ONE OR TWO SQUARES FORWARD ON FIRST MOVE
  # OTHERWISE CAN ONLY MOVE ONE SQUARE FORWARD
  def valid_move?(destination_x, destination_y)
    # byebug if (destination_x == 2 && destination_y == 2)
    return false if super(destination_x, destination_y) == false
    case
    when self.first_move == "first_move_white"
      (destination_y - self.current_y).between?(1, 2) &&
        (destination_x == self.current_x)
    when self.first_move == "first_move_black"
      (self.current_y - destination_y).between?(1, 2) &&
        (destination_x == self.current_x)
    when self.piece_color == "white"
      (destination_y - self.current_y == 1) &&
        (destination_x == self.current_x)
    when self.piece_color == "black"
      (self.current_y - destination_y == 1) && 
        (destination_x == self.current_x)
    else
      false
    end
  end


  def first_move
    return "first_move_white" if self.piece_color == "white" && self.current_y == 1
    return "first_move_black" if self.piece_color == "black" && self.current_y == 6
  end

  def promote(type="Queen")
    self.piece_type = type if 
      (self.piece_color == "white" && self.current_y == 7) ||
      (self.piece_color == "black" && self.current_y == 0)
  end
end
