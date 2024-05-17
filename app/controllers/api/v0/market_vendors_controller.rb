class Api::V0::MarketVendorsController < ApplicationController
  before_action :find_market_and_vendor, only: [:create]

  def create
    market_vendor = MarketVendor.create!(market_id: @market.id, vendor_id: @vendor.id)
    render json: { message: "Successfully added vendor to market" }, status: :created 
  end

  private
  def find_market_and_vendor
    @market = Market.find(params[:market_id])
    @vendor = Vendor.find(params[:vendor_id])
  end
  
  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
                 .serialize_json_market_vendor, status: :not_found
  end
end
