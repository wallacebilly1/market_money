require 'rails_helper'

RSpec.describe MarketVendor, type: :model do
  describe 'relationships' do
    it { belong_to :market }
    it { belong_to :vendor }
  end

  describe 'validations' do
    it {  should validate_presence_of :market_id }
    it {  should validate_presence_of :vendor_id  }
    
    it 'validates the presence of credit_accepted' do
      @market1 = create(:market)
      @vendor1 = create(:vendor)
      @mv1 = MarketVendor.new(market_id: @market1.id, vendor_id: @vendor1.id)
      
      expect(@mv1).to be_valid
      @mv1.save

      @mv_remake = MarketVendor.new(market_id: @market1.id, vendor_id: @vendor1.id)
      expect(@mv_remake).not_to be_valid
      expect(@mv_remake.errors[:validation]).to include("failed: Market vendor asociation between market with market_id=#{@market1.id} and vendor_id=#{@vendor1.id} already exists")
    end
  end
end
