FactoryGirl.define do
  factory :bishop do
    game
    user { FactoryGirl.create(:white_player) }
    starting_position_x 0
    starting_position_y 0 
  end
end
