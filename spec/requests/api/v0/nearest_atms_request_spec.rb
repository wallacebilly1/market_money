require 'rails_helper'

describe "Nearest ATMs API" do
  before(:each) do
    @market_1 = create(:market, state: "New Mexico", city: "Albuquerque", name: "Bee Market", lat: 35.0780, lon: -106.5984)
  end
  
  describe "Nearest ATMs index" do
    it "sends a list of nearest ATMs to a market", :vcr do
      get "/api/v0/markets/#{@market_1.id}/nearest_atms"

      expect(response).to be_successful
  
      atms = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(atms.count).to eq 5
      
      atms.each do |atm|
        expect(atm).to have_key(:id)
        expect(atm[:id]).to be nil

        expect(atm).to have_key(:type)
        expect(atm[:type]).to eq "atm"

        expect(atm[:attributes]).to have_key(:name)
        expect(atm[:attributes][:name]).to be_a(String)
        
        expect(atm[:attributes]).to have_key(:address)
        expect(atm[:attributes][:address]).to be_a(String)
        
        expect(atm[:attributes]).to have_key(:lat)
        expect(atm[:attributes][:lat]).to be_an(Float)
        
        expect(atm[:attributes]).to have_key(:lon)
        expect(atm[:attributes][:lon]).to be_an(Float)
        
        expect(atm[:attributes]).to have_key(:distance)
        expect(atm[:attributes][:distance]).to be_an(Float)
      end
    end

    it "sad path" do

    end
  end
end