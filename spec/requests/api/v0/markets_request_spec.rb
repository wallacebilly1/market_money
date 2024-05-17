require 'rails_helper'

RSpec.describe "Markets API" do
  before(:each) do
    create_list(:market, 4)

    @market_1 = create(:market)
    @mv_1_1 = @market_1.market_vendors.create(vendor: create(:vendor))
    @mv_1_2 = @market_1.market_vendors.create(vendor: create(:vendor))
    @mv_1_3 = @market_1.market_vendors.create(vendor: create(:vendor))
    @mv_1_4 = @market_1.market_vendors.create(vendor: create(:vendor))
  end
  
  describe "Market index" do
    it "sends a list of markets" do
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

  describe "Market show" do
    it "returns all market attributes for a specific market" do
      get "/api/v0/markets/#{@market_1.id}"
  
      expect(response).to be_successful
  
      market = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(market).to have_key(:id)
      expect(market[:id]).to eq(@market_1.id.to_s)

      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to eq(@market_1.name)

      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to eq(@market_1.street)
      
      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes][:city]).to eq(@market_1.city)
      
      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes][:county]).to eq(@market_1.county)
      
      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes][:state]).to eq(@market_1.state)
      
      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes][:zip]).to eq(@market_1.zip)

      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes][:lat]).to eq(@market_1.lat)

      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes][:lon]).to eq(@market_1.lon)

      expect(market[:attributes]).to have_key(:vendor_count)
      expect(market[:attributes][:vendor_count]).to eq(4)
    end

    it "returns a 404 status and error message when an invalid market id is passed in" do
      get "/api/v0/markets/123123123123123"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=123123123123123")
    end
  end

  describe "Market search" do
    before(:each) do
      Market.destroy_all
      @co_markets = create_list(:market, 2, state: "Colorado")
      @ut_market = create(:market, state: "Utah", city: "Provo", name: "Bee Market")
      @nm_market = create(:market, state: "New Mexico", city: "Santa Fe", name: "Bee Market")
    end

    it "returns all market attributes for markets from a state search" do
      get "/api/v0/markets/search?state=Colorado"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(data.count).to eq(2)
      expect(data.first[:attributes][:name]).to eq(@co_markets.first.name)
      expect(data.first[:attributes][:state]).to eq(@co_markets.first.state)
      expect(data.first[:attributes][:city]).to eq(@co_markets.first.city)
    end

    it "returns all market attributes for markets from a city/state search" do
      get "/api/v0/markets/search?city=Provo&state=Utah"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(data.count).to eq(1)
      expect(data.first[:attributes][:name]).to eq(@ut_market.name)
      expect(data.first[:attributes][:state]).to eq(@ut_market.state)
      expect(data.first[:attributes][:city]).to eq(@ut_market.city)
    end

    it "returns all market attributes for markets from a city/state/name search" do
      get "/api/v0/markets/search?city=Provo&state=Utah&name=Bee Market"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(data.count).to eq(1)
      expect(data.first[:attributes][:name]).to eq(@ut_market.name)
      expect(data.first[:attributes][:state]).to eq(@ut_market.state)
      expect(data.first[:attributes][:city]).to eq(@ut_market.city)
    end

    it "returns all market attributes for markets from a state/name search" do
      get "/api/v0/markets/search?state=Utah&name=Bee Market"
      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(data.count).to eq(1)
      expect(data.first[:attributes][:name]).to eq(@ut_market.name)
      expect(data.first[:attributes][:state]).to eq(@ut_market.state)
      expect(data.first[:attributes][:city]).to eq(@ut_market.city)
    end

    it "returns all market attributes for markets from a name search" do
      get "/api/v0/markets/search?name=Bee Market"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(data.count).to eq(2)
      
      expect(data.first[:attributes][:name]).to eq(@ut_market.name)
      expect(data.first[:attributes][:state]).to eq(@ut_market.state)
      expect(data.first[:attributes][:city]).to eq(@ut_market.city)
      expect(data.second[:attributes][:name]).to eq(@nm_market.name)
      expect(data.second[:attributes][:state]).to eq(@nm_market.state)
      expect(data.second[:attributes][:city]).to eq(@nm_market.city)
    end

    it "returns a 422 status and error message when trying to search with just a city" do
      get "/api/v0/markets/search?city=Denver"

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("422")
      expect(data[:errors].first[:title]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
    end

    it "returns a 422 status and error message when trying to search with just a city and name" do
      get "/api/v0/markets/search?city=Denver&name=Pies"
      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("422")
      expect(data[:errors].first[:title]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
    end
  end
end