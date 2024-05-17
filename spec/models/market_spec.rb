require 'rails_helper'

RSpec.describe Market, type: :model do
  describe 'relationships' do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe 'instance methods' do
    describe 'vendor_count' do
      it 'returns the number of vendors associated with a market' do
        @market_1 = create(:market)
        @mv_1_1 = @market_1.market_vendors.create(vendor: create(:vendor))
        @mv_1_2 = @market_1.market_vendors.create(vendor: create(:vendor))
        @mv_1_3 = @market_1.market_vendors.create(vendor: create(:vendor))
        @mv_1_4 = @market_1.market_vendors.create(vendor: create(:vendor))

        expect(@market_1.vendor_count).to eq 4
      end

      it 'returns 0 when there are no vendors associated with a market' do
        @market_2 = create(:market)

        expect(@market_2.vendor_count).to eq 0
      end
    end
  end
end
