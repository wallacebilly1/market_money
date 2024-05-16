class Api::V0::MarketsController < ApplicationController 
  def index 
    markets = Market.all
    render json: MarketSerializer.new(markets)
  end

  def show
    market = Market.find(params[:id])
    render json: MarketSerializer.new(market)
  end

  def search
    markets_search = MarketSearchService.new(params)

    if markets_search.valid?
      render json: MarketSerializer.new(markets_search.results)
    else 
      render json: { errors: [{ status: "422", title: "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."} ] }, status: 422
    end
  end
end