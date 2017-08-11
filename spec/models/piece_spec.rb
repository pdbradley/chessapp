require 'rails_helper'

RSpec.describe Piece, type: :model do

  describe '#possible moves' do
    it 'predicts the moves for the rightmost  white rook' do
      user = FactoryGirl.create(:user)
      game = Game.create(white_player_id: user.id)

      rook = game.pieces.where(current_x: 7, current_y: 0).first
      expect(rook.possible_moves).to match_array []
    end
    it 'predicts the moves for the rightmost white rook when pawn is removed' do
      user = FactoryGirl.create(:user)
      game = Game.create(white_player_id: user.id)
      #kill pawn
      game.pieces.where(current_x: 7, current_y: 1).first.destroy

      rook = game.pieces.where(current_x: 7, current_y: 0).first
      expect(rook.possible_moves).to match_array [[[7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7]]]
    end
    it 'predicts the moves for the leftmost white pawn' do
      user = FactoryGirl.create(:user)
      game = Game.create(white_player_id: user.id)

      pawn = game.pieces.where(current_x: 0, current_y: 1).first
      expect(pawn.possible_moves).to match_array [[0,2], [0,3]]
    end
  end










  it 'has valid factory' do
    expect { FactoryGirl.create(:piece) }.to change { Piece.count }
  end

  it 'has valid factory' do
    expect { FactoryGirl.create(:bishop) }.to change { Piece.count }
  end

  it 'has valid factory' do
    expect { FactoryGirl.create(:rook) }.to change { Piece.count }
  end

  it 'has valid factory' do
    expect { FactoryGirl.create(:pawn) }.to change { Piece.count }
  end

  it 'has valid factory' do
    expect { FactoryGirl.create(:queen) }.to change { Piece.count }
  end

  # MOVE_PIECE

  describe "#move_piece" do
    context "no king in check" do
      it "should save move" do
        game = FactoryGirl.create(:game, :no_pieces)
        white_king = Piece.create(piece_type: 'King', piece_color: 'white', 
                                  game_id: game.id, user_id: game.white_player_id, 
                                  current_x: 4, current_y: 0)
        white_rook = Piece.create(piece_type: 'Rook', piece_color: 'white', 
                                  game_id: game.id, user_id: game.white_player_id, 
                                  current_x: 3, current_y: 0)
        black_rook = Piece.create(piece_type: 'Rook', piece_color: 'black', 
                                  game_id: game.id, user_id: game.black_player_id, 
                                  current_x: 0, current_y: 0)
        destination_x = 3
        destination_y = 1

        white_rook.move_piece(destination_x, destination_y)

        expect(white_rook.current_y).to eq(1)
      end
    end

    # context "own king in check" do
    #   it "should not save move" do
    #     game = FactoryGirl.create(:game, :no_pieces)
    #     white_king = Piece.create(piece_type: 'King', piece_color: 'white', 
    #                               game_id: game.id, user_id: game.white_player_id, 
    #                               current_x: 4, current_y: 0)
    #     white_rook = Piece.create(piece_type: 'Rook', piece_color: 'white', 
    #                               game_id: game.id, user_id: game.white_player_id, 
    #                               current_x: 3, current_y: 0)
    #     black_rook = Piece.create(piece_type: 'Rook', piece_color: 'black', 
    #                               game_id: game.id, user_id: game.black_player_id, 
    #                               current_x: 0, current_y: 0)
    #     destination_x = 3
    #     destination_y = 1

    #     white_rook.move_piece(destination_x, destination_y)

    #     expect(white_rook.current_y).to eq(0)
    #   end
    # end
  end

  # PAWN PROMOTION

  describe 'a queen is a queen' do
    let!(:queen1) { FactoryGirl.create(:queen, current_x: 0, current_y: 0) }
    it 'should just be' do
      expect(queen1.piece_type).to be == "Queen"
    end
  end

  describe 'black pawn is promoted' do
    let!(:pawn1) { FactoryGirl.create(:pawn, piece_color: "black",
                                             current_x: 0, current_y: 0) }
    it 'should be promoted to queen by default' do
      pawn1.promote
      expect(pawn1.piece_type).to be == "Queen"
    end
    
    it 'should be promoted to queen' do
      pawn1.promote("Queen")
      expect(pawn1.piece_type).to be == "Queen"
    end

    it 'should be promoted to rook' do
      pawn1.promote("Rook")
      expect(pawn1.piece_type).to be == "Rook"
    end

    it 'should be promoted to knight' do
      pawn1.promote("Knight")
      expect(pawn1.piece_type).to be == "Knight"
    end

    it 'should be promoted to bishop' do
      pawn1.promote("Bishop")
      expect(pawn1.piece_type).to be == "Bishop"
    end
  end

  describe 'black pawn is NOT promoted' do
    let!(:pawn1) { FactoryGirl.create(:pawn, piece_color: "black",
                                             current_x: 0, current_y: 2) }
    it 'should still be a pawn' do
      pawn1.promote("Queen")
      expect(pawn1.piece_type).to be == "Pawn"
    end
  end

  describe 'white pawn is promoted' do
    let!(:pawn1) { FactoryGirl.create(:pawn, piece_color: "white",
                                             current_x: 0, current_y: 7) }
    it 'should be promoted to queen' do
      pawn1.promote("Queen")
      expect(pawn1.piece_type).to be == "Queen"
    end

    it 'should be promoted to rook' do
      pawn1.promote("Rook")
      expect(pawn1.piece_type).to be == "Rook"
    end

    it 'should be promoted to knight' do
      pawn1.promote("Knight")
      expect(pawn1.piece_type).to be == "Knight"
    end

    it 'should be promoted to bishop' do
      pawn1.promote("Bishop")
      expect(pawn1.piece_type).to be == "Bishop"
    end
  end

  describe 'white pawn is NOT promoted' do
    let!(:pawn1) { FactoryGirl.create(:pawn, piece_color: "white",
                                             current_x: 0, current_y: 3) }
    it 'should still be a pawn' do
      pawn1.promote("Queen")
      expect(pawn1.piece_type).to be == "Pawn"
    end
  end

  # VALID MOVES

  describe "valid_move?" do
    context "off board" do
      let!(:king1) { FactoryGirl.create(:king, current_x: 0, current_y: 0) }
      let!(:king2) { FactoryGirl.create(:king, current_x: 7, current_y: 7) }
      let(:current_x_king1) { 0 }
      let(:current_y_king1) { 0 }
      let(:current_x_king2) { 7 }
      let(:current_y_king2) { 7 }
      let(:dest_x_offboard_right) { 8 }
      let(:dest_x_offboard_left) { -1 }
      let(:dest_y_offboard_top) { 8 }
      let(:dest_y_offboard_bottom) { -1 }

      it "should be false for off board move to right" do
        expect(king2.valid_move?(dest_x_offboard_right, current_y_king2)).to be false
      end

      it "should be false for off board move to left" do
        expect(king1.valid_move?(dest_x_offboard_left, current_y_king1)).to be false
      end

      it "should be false for off board move to top" do
        expect(king2.valid_move?(current_x_king2, dest_y_offboard_top)).to be false
      end

      it "should be false for off board move to bottom" do
        expect(king1.valid_move?(current_x_king1, dest_y_offboard_bottom)).to be false
      end

      it "should only let a pawn make a legal move" do
        pawn = FactoryGirl.create(:pawn, current_x: 0, current_y: 0)
        expect(pawn.valid_move?(2,2)).to be false
      end
    end
  end

# HORIZONTAL OBSTRUCTION

  describe 'piece obstructed horizontally' do
    context 'left to right' do
      let!(:rook1) { FactoryGirl.create(:rook, current_x: 0, current_y: 0) }
      let!(:rook2) { FactoryGirl.create(:rook, current_x: 3, current_y: 0) }
      let!(:rook3) { FactoryGirl.create(:rook, current_x: 5, current_y: 0) }
      let(:dest_x) { 5 }
      let(:dest_y) { 0 }
      it 'should return true (move 0,0 to 5,0 blocked on 3,0)' do
        expect(rook1.is_move_blocked(dest_x,dest_y)).to be true
      end
    end

    context 'left to right - edge case - piece on destination position' do
      let!(:rook1) { FactoryGirl.create(:rook, current_x: 0, current_y: 0) }
      let!(:rook2) { FactoryGirl.create(:rook, current_x: 3, current_y: 0) }
      let(:dest_x) { 3 }
      let(:dest_y) { 0 }
      it 'should return false (move 0,0 to 3,0 another piece on 3,0)' do
        expect(rook1.is_move_blocked(dest_x,dest_y)).to be false
      end
    end

    context 'right to left' do
      let!(:rook1) { FactoryGirl.create(:rook, current_x: 5, current_y: 0) }
      let!(:rook2) { FactoryGirl.create(:rook, current_x: 3, current_y: 0) }
      let!(:rook3) { FactoryGirl.create(:rook, current_x: 0, current_y: 0) }
      let(:dest_x) { 0 }
      let(:dest_y) { 0 }
      it 'should return true (move 5,0 to 0,0 blocked on 3,0)' do
        expect(rook1.is_move_blocked(dest_x,dest_y)).to be true
      end
    end

    context 'right to left - edge case - piece on destination position' do
      let!(:rook1) { FactoryGirl.create(:rook, current_x: 5, current_y: 0) }
      let!(:rook2) { FactoryGirl.create(:rook, current_x: 3, current_y: 0) }
      let(:dest_x) { 3 }
      let(:dest_y) { 0 }
      it 'should return false (move 5,0 to 3,0 another piece on 3,0)' do
        expect(rook1.is_move_blocked(dest_x,dest_y)).to be false
      end
    end

  end

  describe 'piece NOT obstructed horizontally' do
    let!(:rook1) { FactoryGirl.create(:rook, current_x: 0, current_y: 0) }
    let!(:rook2) { FactoryGirl.create(:rook, current_x: 5, current_y: 0) }
    let(:dest_x) { 3 }
    let(:dest_y) { 0 }
    it 'should return false (move 0,0 to 3,0)' do
      expect(rook1.is_move_blocked(dest_x,dest_y)).to be false
    end
    it 'should return false (move 5,0 to 3,0)' do
      expect(rook2.is_move_blocked(dest_x,dest_y)).to be false
    end
  end

# VERTICAL OBSTRUCTION

describe 'piece obstructed vertically' do
  context 'bottom to top' do
    let!(:rook1) { FactoryGirl.create(:rook, current_x: 0, current_y: 0) }
    let!(:rook2) { FactoryGirl.create(:rook, current_x: 0, current_y: 3) }
    let!(:rook3) { FactoryGirl.create(:rook, current_x: 0, current_y: 5) }
    let(:dest_x) { 0 }
    let(:dest_y) { 5 }
    it 'should return true (move 0,0 to 0,5 blocked on 0,3)' do
      expect(rook1.is_move_blocked(dest_x,dest_y)).to be true
    end
  end

  context 'bottom to top - edge case - piece on destination position' do
    let!(:rook1) { FactoryGirl.create(:rook, current_x: 0, current_y: 0) }
    let!(:rook2) { FactoryGirl.create(:rook, current_x: 0, current_y: 3) }
    let(:dest_x) { 0 }
    let(:dest_y) { 3 }
    it 'should return false (move 0,0 to 0,3 another piece on 0,3)' do
      expect(rook1.is_move_blocked(dest_x,dest_y)).to be false
    end
  end

  context 'top to bottom' do
    let!(:rook1) { FactoryGirl.create(:rook, current_x: 0, current_y: 5) }
    let!(:rook2) { FactoryGirl.create(:rook, current_x: 0, current_y: 3) }
    let!(:rook3) { FactoryGirl.create(:rook, current_x: 0, current_y: 0) }
    let(:dest_x) { 0 }
    let(:dest_y) { 0 }
    it 'should return true (move 0,5 to 0,0 blocked on 0,3)' do
      expect(rook1.is_move_blocked(dest_x,dest_y)).to be true
    end
  end

  context 'top to bottom - edge case - piece on destination position' do
    let!(:rook1) { FactoryGirl.create(:rook, current_x: 0, current_y: 5) }
    let!(:rook2) { FactoryGirl.create(:rook, current_x: 0, current_y: 0) }
    let(:dest_x) { 0 }
    let(:dest_y) { 0 }
    it 'should return false (move 0,5 to 0,0, another piece on 0,0)' do
      expect(rook1.is_move_blocked(dest_x,dest_y)).to be false
    end
  end
end

describe 'piece NOT obstructed vertically' do
  let!(:rook1) { FactoryGirl.create(:rook, current_x: 0, current_y: 0) }
  let!(:rook2) { FactoryGirl.create(:rook, current_x: 0, current_y: 5) }
  let!(:rook3) { FactoryGirl.create(:rook, current_x: 0, current_y: 3) }
  let(:dest_x) { 0 }
  let(:dest_y) { 3 }
  it 'should return false (move 0,0 to 0,3)' do
    expect(rook1.is_move_blocked(dest_x,dest_y)).to be false
  end
  it 'should return false (move 0,5 to 0,3)' do
    expect(rook2.is_move_blocked(dest_x,dest_y)).to be false
  end
end

# DIAGONAL OBSTRUCTION

describe 'piece obstructed diagonally' do
  context 'bottom right to upper left' do
    let!(:bishop1) { FactoryGirl.create(:bishop, current_x: 7, current_y: 0) }
    let!(:bishop2) { FactoryGirl.create(:bishop, current_x: 3, current_y: 4) }
    let(:dest_x) { 0 }
    let(:dest_y) { 7 }
    it 'should return true (move 7,0 to 0,7 blocked on 3,4)' do
      expect(bishop1.is_move_blocked(dest_x,dest_y)).to be true
    end
  end

  context 'bottom right to upper left - edge case - piece on destination position' do
    let!(:bishop1) { FactoryGirl.create(:bishop, current_x: 7, current_y: 0) }
    let!(:bishop2) { FactoryGirl.create(:bishop, current_x: 3, current_y: 4) }
    let(:dest_x) { 3 }
    let(:dest_y) { 4 }
    it 'should return false (move 7,0 to 3,4 -  another piece on 3,4)' do
      expect(bishop1.is_move_blocked(dest_x,dest_y)).to be false
    end
  end

  context 'upper right to bottom left' do
    let!(:bishop1) { FactoryGirl.create(:bishop, current_x: 0, current_y: 7) }
    let!(:bishop2) { FactoryGirl.create(:bishop, current_x: 3, current_y: 4) }
    let(:dest_x) { 7 }
    let(:dest_y) { 0 }
    it 'should return true (move 0,7 to 7,0 blocked on 3,4)' do
      expect(bishop1.is_move_blocked(dest_x ,dest_y)).to be true
    end
  end

  context 'upper right to bottom left - edge case - piece on destination position' do
    let!(:bishop1) { FactoryGirl.create(:bishop, current_x: 0, current_y: 7) }
    let!(:bishop2) { FactoryGirl.create(:bishop, current_x: 3, current_y: 4) }
    let(:dest_x) { 3 }
    let(:dest_y) { 4 }
    it 'should return false (move 0,7 to 3,4 - another piece on 3,4)' do
      expect(bishop1.is_move_blocked(dest_x ,dest_y)).to be false
    end
  end
end

describe 'bottom left to upper right' do
  let!(:bishop1) { FactoryGirl.create(:bishop, current_x: 0, current_y: 0) }
  let!(:bishop2) { FactoryGirl.create(:bishop, current_x: 4, current_y: 4) }
  let(:dest_x) { 7 }
  let(:dest_y) { 7 }
  it 'should return true (move 0,0 to 7,7 blocked on 4,4)' do
    expect(bishop1.is_move_blocked(dest_x,dest_y)).to be true
  end
end

describe 'bottom left to upper right - edge case - piece on destination position' do
  let!(:bishop1) { FactoryGirl.create(:bishop, current_x: 0, current_y: 0) }
  let!(:bishop2) { FactoryGirl.create(:bishop, current_x: 4, current_y: 4) }
  let(:dest_x) { 4 }
  let(:dest_y) { 4 }
  it 'should return false (move 0,0 to 4,4  - another piece on 4,4)' do
    expect(bishop1.is_move_blocked(dest_x,dest_y)).to be false
  end
end

describe 'upper right to bottom left' do
  let!(:bishop1) { FactoryGirl.create(:bishop, current_x: 7, current_y: 7) }
  let!(:bishop2) { FactoryGirl.create(:bishop, current_x: 4, current_y: 4) }
  let(:dest_x) { 0 }
  let(:dest_y) { 0 }
  it 'should return true (move 7,7 to 0,0 blocked on 4,4)' do
    expect(bishop1.is_move_blocked(dest_x,dest_y)).to be true
  end
end

describe 'upper right to bottom left - edge case - piece on destination position' do
  let!(:bishop1) { FactoryGirl.create(:bishop, current_x: 7, current_y: 7) }
  let!(:bishop2) { FactoryGirl.create(:bishop, current_x: 4, current_y: 4) }
  let(:dest_x) { 4 }
  let(:dest_y) { 4 }
  it 'should return false (move 7,7 to 4,4 - another piece on 4,4)' do
    expect(bishop1.is_move_blocked(dest_x,dest_y)).to be false
  end
end


describe 'piece NOT obstructed' do
    #one piece in each corner
    let!(:bishop1) { FactoryGirl.create(:bishop, current_x: 0, current_y: 0) }
    let!(:bishop2) { FactoryGirl.create(:bishop, current_x: 0, current_y: 7) }
    let!(:bishop3) { FactoryGirl.create(:bishop, current_x: 7, current_y: 0) }
    let!(:bishop4) { FactoryGirl.create(:bishop, current_x: 7, current_y: 7) }

    let(:dest_x) { 4 }
    let(:dest_y) { 4 }

    context 'upper left to bottom right and viceversa' do
      it 'should return false (move 0,0 to 4,4)' do
        expect(bishop1.is_move_blocked(dest_x,dest_y)).to be false
      end
      it 'should return false (move 0,7 to 4,4)' do
        expect(bishop2.is_move_blocked(dest_x ,dest_y)).to be false
      end
    end

    context 'upper right to bottom left and viceversa' do
      it 'should return false (move 7,0 to 4,4)' do
        expect(bishop3.is_move_blocked(dest_x,dest_y)).to be false
      end
      it 'should return false (move 7,7 to 4,4)' do
        expect(bishop4.is_move_blocked(dest_x ,dest_y)).to be false
      end
    end
 end
end
