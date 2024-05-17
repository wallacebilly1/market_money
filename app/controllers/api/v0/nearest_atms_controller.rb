class Api::V0::NearestAtmsController < ApplicationController
  def index 
    atms = AtmFacade.new(params[:market_id]).nearest_atms
    render json: AtmSerializer.format_atms(atms)
  end
end
