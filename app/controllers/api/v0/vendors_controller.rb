class Api::V0::VendorsController < ApplicationController 
  def index 
    market = Market.find(params[:market_id])
    vendors = market.vendors
    render json: VendorSerializer.new(vendors)
  end

  def show

  end
end