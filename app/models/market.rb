class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  def vendor_count
    vendors.size || 0

    # if vendors.exists? 
    #   vendors.size
    # else 
    #   0 
    # end
    
  end
end
