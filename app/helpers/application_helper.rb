module ApplicationHelper

# needs to be moved to games_helper.rb, file missing?
  def piece_at_location(pieces, row, col)
    pieces.each do |piece|
      return piece if (piece.current_position_x == col && piece.current_position_y == row)
    end
    nil
  end
end
