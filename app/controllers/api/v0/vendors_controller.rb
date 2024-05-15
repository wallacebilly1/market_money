class Api::V0::VendorsController < ApplicationController 
  def index 
    market = Market.find(params[:market_id])
    vendors = market.vendors
    render json: VendorSerializer.new(vendors)
  end

  def show
    vendor = Vendor.find(params[:id])
    render json: VendorSerializer.new(vendor)
  end

  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save
      render json: VendorSerializer.new(vendor), status: 201
    else
      # error message
    end
  end

  private
  def vendor_params
    params.require(:vendor).permit( :name, 
                                    :description, 
                                    :contact_name, 
                                    :contact_phone, 
                                    :credit_accepted 
                                  )
  end
end