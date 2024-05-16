require 'rails_helper'

RSpec.describe AtmFacade do
  before(:each) do
    @market1 = create(:market)
    @facade = AtmFacade.new(@market1.id)
  end

  it 'exists and has a market id attr', :vcr do
    expect(@facade).to be_a(AtmFacade)
    expect(@facade.instance_variable_get(:@market_id)).to eq(@market1.id)
  end

  it 'returns an array of nearby atms', :vcr do
    expect(@facade.nearest_atms).to be_an(Array)
    @facade.nearest_atms.each do |atm|
      expect(atm).to be_a(Atm)
    end
  end
end