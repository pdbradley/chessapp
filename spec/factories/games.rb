FactoryGirl.define do
  factory :game do
    trait :full do
      white_player { FactoryGirl.create(:white_player) }
      black_player { FactoryGirl.create(:black_player) }
      game_status "Full"
    end

    trait :no_wh do

      black_player { FactoryGirl.create(:black_player) }
 
      game_status "Open"
    end

    trait :no_bl do
      white_player { FactoryGirl.create(:white_player) }
      game_status "Open"
    end

    trait :no_players do
      game_status "Open"
    end
  end
end