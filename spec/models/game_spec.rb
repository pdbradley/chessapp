require 'rails_helper'

RSpec.describe Game, type: :model do
  describe ".set_game_board" do
    it "should increate piece count by 32" do
      game = FactoryGirl.create(:game, :full)
      expect(Piece.where(game_id: game.id).count).to eq(32)
    end
  
    it ".set_game_board is called after game creation" do
      game = FactoryGirl.build(:game)
      expect(game).to receive(:set_game_board)
      game.save
    end
  end

  describe "initial turn" do
    it "should return white as the first turn" do
      game = FactoryGirl.build(:game)
      expect(game.turn).to eq("white")
    end
  end

  describe "change turns" do
    it "should change to black from white" do
      game = FactoryGirl.build(:game)
      game.turn_change
      expect(game.turn).to eq("black")
    end

    it "should change to black and back to white" do
      game = FactoryGirl.build(:game)
      game.turn_change
      expect(game.turn).to eq("black")
      game.turn_change
      expect(game.turn).to eq("white")
    end
  end

  describe Game, "scope" do
    it "Show games with white and black player present as closed" do
      game = FactoryGirl.create(:game, :full) 
      expect(Game.available.map(&:game_status)[0]).to eq(nil)
    end

    it "Shows games with white player present but no black player as open" do
      game = FactoryGirl.create(:game, :no_bl)
      expect(Game.available.map(&:game_status) [0]).to eq(game.game_status)
    end

    it "Shows games with white player not present but back player present as open" do
      game = FactoryGirl.create(:game, :no_wh)
      expect(Game.available.map(&:game_status) [0]).to eq(game.game_status)
    end

    it "Shows games with no white or black player present as open" do
      game = FactoryGirl.create(:game, :no_players) 
      expect(Game.available.map(&:game_status) [0]).to eq(game.game_status)    
    end
  end

  # CHECK METHOD

  describe "#check" do                                  
    it "white in check" do 
      game = FactoryGirl.create(:game, :no_pieces)
      white_king = Piece.create(piece_type: 'King', piece_color: 'white', game_id: game.id,
                          user_id: game.white_player_id, current_x: 4, current_y: 0)
      black_king = Piece.create(piece_type: 'King', piece_color: 'black', game_id: game.id,
                          user_id: game.black_player_id, current_x: 4, current_y: 7)
      black_rook = Piece.create(piece_type: 'Rook', piece_color: 'black', game_id: game.id,
                          user_id: game.black_player_id, current_x: 0, current_y: 0)

      expect(game.check).to eq(true)
    end

    it "black in check" do 
      game = FactoryGirl.create(:game, :no_pieces)
      white_king = Piece.create(piece_type: 'King', piece_color: 'white', game_id: game.id,
                          user_id: game.white_player_id, current_x: 4, current_y: 0)
      black_king = Piece.create(piece_type: 'King', piece_color: 'black', game_id: game.id,
                          user_id: game.black_player_id, current_x: 4, current_y: 7)
      white_rook = Piece.create(piece_type: 'Rook', piece_color: 'white', game_id: game.id,
                          user_id: game.white_player_id, current_x: 0, current_y: 7)
      game.turn = "black"

      expect(game.check).to eq(true)
    end

    it "not in check" do 
      game = FactoryGirl.create(:game, :no_pieces)
      white_king = Piece.create(piece_type: 'King', piece_color: 'white', game_id: game.id,
                          user_id: game.white_player_id, current_x: 4, current_y: 0)
      black_king = Piece.create(piece_type: 'King', piece_color: 'black', game_id: game.id,
                          user_id: game.black_player_id, current_x: 4, current_y: 7)
      white_bishop = Piece.create(piece_type: 'Bishop', piece_color: 'white', game_id: game.id,
                          user_id: game.white_player_id, current_x: 0, current_y: 7)

      expect(game.check).to eq(false)
    end
  end

  # CHECKMATE METHOD
  #.......K
  #........
  #.......Q
  #........
  #........
  #........
  #........
  #........
  describe "#king_taken_next_move?" do
    it "king is exposed to be taken"
      game = FactoryGirl.create(:game, :no_pieces)
      black_king = Piece.create(piece_type: 'King', piece_color: 'black', game_id: game.id,
                          user_id: game.black_player_id, current_x: 7, current_y: 7)
      white_queen = Piece.create(piece_type: 'Queen', piece_color: 'white', game_id: game.id, user_id: game.white_player_id, current_x: 7, current_y: 5)

      expect(game.king_taken_next_move?).to eq(true)
    end

  end
  # STALEMATE METHOD
  # describe "#stalemate?" do
  #   it "should return true" do
  #     game = FactoryGirl.create(:game)
  #     expect(game.stalemate?).to eq true
  #   end

  #   it "should return false" do
  #     game = FactoryGirl.create(:game)
  #     expect(game.stalemate?).to eq false
  #   end
  # end

end
