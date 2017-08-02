class PiecesController < ApplicationController
  before_action :authenticate_user!

  def new
    @piece = Piece.new
  end

  def create
    @piece = Piece.new(piece_params)
    if @piece.save
      render :show, status: :created
    else
      render :new, status: :unprocessable_entity # 422
    end
  end

  def update
    binding.pry
    # piece = Piece.find(params[:id])
    # @game = piece.game
    # piece.update_attributes(piece_params)
    # redirect_to game_path(@game)
  end

  private

  def piece_params
    params.require(:piece).permit(:piece_type, :piece_color, :current_position_x, 
        :current_position_y)
  end
end
