require 'rails_helper'

RSpec.describe Game, type: :model do
  describe Game, "scope" do
    it "Show games with white and black player present as closed" do
      # user1 = FactoryGirl.create(:white_player)
      # user2 = FactoryGirl.create(:black_player) 
      # post :create, { params: { white_player: user1.id, black_player: user2.id, game_status: "In play"}}
      # FactoryGirl.create(:game)
      game = FactoryGirl.create(:game, :full) 
     

      expect(game.avail).to eq(false)
      # game = FactoryGirl.create(:game)

    end

    it "Shows games with white player present but no black player as open" do
      game = FactoryGirl.create(:game, :no_bl)
      expect(game.avail).to eq(true)
    end

    it "Shows games with white player not present but back player present as open" do
      game = FactoryGirl.create(:game, :no_wh)
      expect(game.avail).to eq(true)
    end

    it "Shows games with no white or black player present as open" do
      game = FactoryGirl.create(:game, :no_players) 
     

      expect(game.avail).to eq(true)    
    end

  end
end