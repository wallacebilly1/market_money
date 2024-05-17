class Api::V0::MarketVendorsController < ApplicationController
  before_action :find_market_and_vendor, only: [:create]

  def create
    market_vendor = MarketVendor.new(market_id: @market.id, vendor_id: @vendor.id)

    if market_vendor.save
      created_message_response("Successfully added vendor to market")
    else
      render_error_already_exists_response(market_vendor.errors)
    end
  end



  private
  
  def find_market_and_vendor
    @market = Market.find(params[:market_id])
    @vendor = Vendor.find(params[:vendor_id])
  end
  
  def created_message_response(message)
    render json: { message: message }, status: :created
  end

  def render_error_already_exists_response(exception)
    message = exception.full_messages.first
    render json: ErrorSerializer.new(ErrorMessage.new(message, 422))
          .serialize_json, status: :unprocessable_entity
  end


  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
          .serialize_json_market_vendor, status: :not_found
  end


end
