require 'rails_helper'

describe "Markets API" do
  it "sends a list of markets" do
    create_list(:market, 4)

    @market_1 = create(:market)
    @mv_1_1 = @market_1.market_vendors.create(vendor: create(:vendor))
    @mv_1_2 = @market_1.market_vendors.create(vendor: create(:vendor))
    @mv_1_3 = @market_1.market_vendors.create(vendor: create(:vendor))
    @mv_1_4 = @market_1.market_vendors.create(vendor: create(:vendor))

    get '/api/v0/markets'

    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(markets.count).to eq(5)
    
    markets.each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(String)

      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_an(String)

      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to be_an(String)
      
      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes][:city]).to be_an(String)
      
      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes][:county]).to be_an(String)
      
      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes][:state]).to be_an(String)
      
      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes][:zip]).to be_an(String)

      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes][:lat]).to be_an(String)

      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes][:lon]).to be_an(String)
      expect(market[:attributes][:vendor_count]).to be_an(Integer)
    end

  end
end