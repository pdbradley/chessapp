require 'rails_helper'

RSpec.describe King, type: :model do
  it "King should inherit behavior from Piece" do 
    expect(King.superclass).to eq(Piece)
  end
end