class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor
  
  validates_presence_of :market_id
  validates_presence_of :vendor_id
  validate :market_vendor_can_not_already_exist, on: :create

  def market_vendor_can_not_already_exist
    existing_market_vendor = MarketVendor.find_by(market_id: market_id, vendor_id: vendor_id)
    errors.add(:base, "Market vendor association between market with market_id=#{market_id} and vendor_id=#{vendor_id} already exists") if existing_market_vendor
  end
end