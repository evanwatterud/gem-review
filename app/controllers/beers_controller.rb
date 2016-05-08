class BeersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @beers = Beer.all
  end

  def new
    @beer = Beer.new
  end

  def show
    @beer = Beer.find(params[:id])
  end

  def create
    @beer = Beer.new(beer_params)
    @beer.user_id = current_user.id

    if @beer.save
      redirect_to @beer, notice: "Successfully added #{@beer.name}."
    else
      render :new
    end
  end

  protected
  def beer_params
    params.require(:beer).permit(:name, :brewer, :style, :brewing_country, :abv)
  end
end
