class Api::V0::MarketVendorsController < ApplicationController
  before_action :find_market_and_vendor, only: [:create]

  def create
    market_vendor = MarketVendor.create!(market_id: @market.id, vendor_id: @vendor.id)
    render json: { message: "Successfully added vendor to market" }, status: :created 
  end

  def destroy 
    @market = Market.find(params[:market_id])
    @vendor = Vendor.find(params[:vendor_id])
    market_vendor = MarketVendor.find_by(market_vendor_params)

    market_vendor.destroy

    render json: MarketVendorSerializer.new(market_vendor),status: 204
  end

  private
  def find_market_and_vendor
    @market = Market.find(params[:market_id])
    @vendor = Vendor.find(params[:vendor_id])
  end
  
  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
                 .serialize_json, status: :not_found
  end

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end
end
