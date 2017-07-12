class Game < ApplicationRecord
  belongs_to :white_player, class_name: 'User'
  belongs_to :black_player, class_name: 'User'

  has_many :pieces
  has_many :moves

  validates :white_player, presence: true
  validates :black_player, presence: true
  validates :game_status, presence: true

  # scope :avail, -> {where(avail: true)}

  def avail
    if white_player.present? == false
      return true
    elsif black_player.present? == false
      return true
    else
      return false
      end 
  end
end