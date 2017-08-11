FactoryGirl.define do  
  factory :user do
    password "secretPassword"
    password_confirmation "secretPassword"
    first_name "John"
    sequence(:username) { |n| "chessmaster#{n}" }
    sequence(:email) { |n| "chessmaster#{n}@nowhere.com" }
  end

  factory :white_player, parent: :user do
    sequence(:email) { |n| "white_player#{n}@gmail.com" }
  end

  factory :black_player, parent: :user do
    sequence(:email) { |n| "black_player#{n}@gmail.com" }
  end
end
