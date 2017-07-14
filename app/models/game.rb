class Game < ApplicationRecord

  STATUSES = [:open, :in_progress, :complete]

  belongs_to :white_player, class_name: 'User', optional: true
  belongs_to :black_player, class_name: 'User', optional: true

  has_many :pieces
  has_many :moves

  validates :white_player, presence: true, allow_blank: true
  validates :black_player, presence: true, allow_blank: true
  validates :game_status, presence: true

  scope :available, -> { where(black_player_id: nil) }
end
