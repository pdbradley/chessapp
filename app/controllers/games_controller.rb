class GamesController < ApplicationController
  before_action :authenticate_user!

  def index
    @games = Game.available
  end

  def show
    @game = Game.find_by(id: params[:id])
    @pieces = @game.pieces
  end


  def create
    @game = Game.new(game_status: :open, white_player: current_user)
    @piece_params_hashes = [
      { piece_type: "Pawn", piece_color: "white", current_position_x: 0, current_position_y: 1 },
      { piece_type: "Pawn", piece_color: "white", current_position_x: 1, current_position_y: 1 },
      { piece_type: "Pawn", piece_color: "white", current_position_x: 2, current_position_y: 1 },
      { piece_type: "Pawn", piece_color: "white", current_position_x: 3, current_position_y: 1 },
      { piece_type: "Pawn", piece_color: "white", current_position_x: 4, current_position_y: 1 },
      { piece_type: "Pawn", piece_color: "white", current_position_x: 5, current_position_y: 1 },
      { piece_type: "Pawn", piece_color: "white", current_position_x: 6, current_position_y: 1 },
      { piece_type: "Pawn", piece_color: "white", current_position_x: 7, current_position_y: 1 },
      { piece_type: "Rook", piece_color: "white", current_position_x: 0, current_position_y: 0 },
      { piece_type: "Rook", piece_color: "white", current_position_x: 7, current_position_y: 0 },
      { piece_type: "Knight", piece_color: "white", current_position_x: 1, current_position_y: 0 },
      { piece_type: "Knight", piece_color: "white", current_position_x: 6, current_position_y: 0 },
      { piece_type: "Bishop", piece_color: "white", current_position_x: 2, current_position_y: 0 },
      { piece_type: "Bishop", piece_color: "white", current_position_x: 5, current_position_y: 0 },
      { piece_type: "King", piece_color: "white", current_position_x: 4, current_position_y: 0 },
      { piece_type: "Queen", piece_color: "white", current_position_x: 3, current_position_y: 0 },
      { piece_type: "Pawn", piece_color: "black", current_position_x: 0, current_position_y: 6 },
      { piece_type: "Pawn", piece_color: "black", current_position_x: 1, current_position_y: 6 },
      { piece_type: "Pawn", piece_color: "black", current_position_x: 2, current_position_y: 6 },
      { piece_type: "Pawn", piece_color: "black", current_position_x: 3, current_position_y: 6 },
      { piece_type: "Pawn", piece_color: "black", current_position_x: 4, current_position_y: 6 },
      { piece_type: "Pawn", piece_color: "black", current_position_x: 5, current_position_y: 6 },
      { piece_type: "Pawn", piece_color: "black", current_position_x: 6, current_position_y: 6 },
      { piece_type: "Pawn", piece_color: "black", current_position_x: 7, current_position_y: 6 },
      { piece_type: "Rook", piece_color: "black", current_position_x: 7, current_position_y: 7 },
      { piece_type: "Rook", piece_color: "black", current_position_x: 0, current_position_y: 7 },
      { piece_type: "Knight", piece_color: "black", current_position_x: 1, current_position_y: 7 },
      { piece_type: "Knight", piece_color: "black", current_position_x: 6, current_position_y: 7 },
      { piece_type: "Bishop", piece_color: "black", current_position_x: 2, current_position_y: 7 },
      { piece_type: "Bishop", piece_color: "black", current_position_x: 5, current_position_y: 7 },
      { piece_type: "King", piece_color: "black", current_position_x: 4, current_position_y: 7 },
      { piece_type: "Queen", piece_color: "black", current_position_x: 3, current_position_y: 7 },
    ]

    if @game.save
      @piece_params_hashes.each do |piece_params|
        piece_params[:user] = current_user
        @game.pieces << Piece.create(piece_params)
      end


      # render :show, status: :created
      redirect_to @game, notice: 'Game was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @game = Game.find_by(id: params[:id])
    
    if @game
      @game.update(game_params)
      redirect_to @game, notice: 'Game was successfully updated.'
    else
      render :edit
    end
  end

  private

  def game_params
    params.require(:game).permit(:white_player_id, :black_player_id, :game_status)
  end
end
