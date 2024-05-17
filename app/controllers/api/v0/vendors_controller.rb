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
      raise ActiveModel::ValidationError, vendor
    end

    # vendor.save!
    # render json: VendorSerializer.new(vendor), status: 201

    # we can do something like this later on in our refactor for the create and update 
  end

  def destroy
    vendor = Vendor.find(params[:id])
    vendor.destroy

    render json: VendorSerializer.new(vendor),status: 204
  end

  def update 
    vendor = Vendor.find(params[:id])
    if vendor.update(vendor_params)
      render json: VendorSerializer.new(vendor), status: 200
    else
      raise ActiveModel::ValidationError, vendor
      # render json: { errors: vendor.errors.full_messages }, status: 400
    end
  end


  private
  def vendor_params
    params.require(:vendor)
          .permit( :name, 
                   :description, 
                   :contact_name, 
                   :contact_phone, 
                   :credit_accepted 
                 )
  end
end