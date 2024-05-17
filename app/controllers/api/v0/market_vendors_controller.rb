class Api::V0::MarketVendorsController < ApplicationController
  before_action :find_market_and_vendor, only: [:create]

  def create
    market_vendor = MarketVendor.create!(market_id: @market.id, vendor_id: @vendor.id)
    render json: { message: "Successfully added vendor to market" }, status: :created 
  end

  def destroy 
    market_vendor = MarketVendor.find(params[:id])
    # if market_vendor.destroy
    #   render json: { message: "" }, status: 204
    # else 
    #   require 'pry'; binding.pry
    #   render json: { errors: [{title: "No MarketVendor with market_id=#{@market.id} AND vendor_id=#{@vendor.id} exists"}]}, status: 404
    # end

    if market_vendor.present? == false 
      render json: { errors: [{title: "No MarketVendor with market_id=#{@market.id} AND vendor_id=#{@vendor.id} exists"}]}, status: 404
    else 
      market_vendor.destroy
      render json: { message: "" }, status: 204
    end
    
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
