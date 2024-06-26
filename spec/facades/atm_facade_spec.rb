require 'rails_helper'

RSpec.describe AtmFacade do
  before(:each) do
    @market1 = create(:market, lat: 35.07904, lon: -106.60068)
    @facade = AtmFacade.new(@market1.id)
  end

  it 'exists and has a market id attr' do
    expect(@facade).to be_a(AtmFacade)
    expect(@facade.instance_variable_get(:@market_id)).to eq(@market1.id)
  end

  it 'returns an array of nearest atms', :vcr do
    expect(@facade.nearest_atms).to be_an(Array)
    @facade.nearest_atms.each do |atm|
      expect(atm).to be_a(Atm)
    end
  end
end