require "rails_helper"

RSpec.describe "MarketVendors" do

  describe "Market Vendor API" do
   
    it 'can create a new market vendor' do
      market = create(:market)
      vendor = create(:vendor)

      post "/api/v0/market_vendors", params: { "market_id": market.id, "vendor_id": vendor.id } 

      data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      expect(data).to be_an(Hash)
      expect(data).to have_key(:message)
      expect(data[:message]).to eq("Successfully added vendor to market")
    end

    it "sad path 1" do 
      vendor = create(:vendor)

      post "/api/v0/market_vendors", params: { "market_id": "1212322", "vendor_id": vendor.id } 

      data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(data[:errors].first[:title]).to eq("Validation Failed: Market must exist")

    end

    it "sad path 1/2" do 
      market = create(:market)

      post "/api/v0/market_vendors", params: { "market_id": market.id, "vendor_id": "123" } 

      data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(data[:errors].first[:title]).to eq("Validation Failed: Vendor must exist")

    end

    it 'it will raise an error if the market vendor already exists' do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor = create(:market_vendor, vendor_id: vendor.id, market_id: market.id)
            
      post "/api/v0/market_vendors", params: { "market_id": market.id, "vendor_id": vendor.id } 
            
      data = JSON.parse(response.body, symbolize_names: true)
            
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      expect(data).to have_key(:errors)
      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:title]).to eq("Validation failed: Market vendor asociation between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists")
    end
  end
end