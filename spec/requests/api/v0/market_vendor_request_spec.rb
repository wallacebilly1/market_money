require "rails_helper"

RSpec.describe "MarketVendors API" do
  describe "MarketVendor create" do
    it 'can create a new market vendor when passed appropriate market and vendor id' do
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

    it "returns a 404 status and error message when an invalid market_id or vendor_id is passed in" do 
      vendor = create(:vendor)
      market = create(:market)

      post "/api/v0/market_vendors", params: { "market_id": "1212322", "vendor_id": vendor.id } 

      data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(data[:errors].first[:title]).to eq("Validation Failed: Market must exist")

      post "/api/v0/market_vendors", params: { "market_id": market.id, "vendor_id": "123123123" } 

      data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(data[:errors].first[:title]).to eq("Validation Failed: Vendor must exist")
    end

    it 'returns a 422 status and error message when trying to create a market vendor that already exists' do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor = create(:market_vendor, vendor_id: vendor.id, market_id: market.id)
            
      post "/api/v0/market_vendors", params: { "market_id": market.id, "vendor_id": vendor.id } 
            
      data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      expect(data).to have_key(:errors)
      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:title]).to eq("Validation failed: Market vendor association between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists")
    end
  end

  describe "MarketVendor destroy" do
    it "deletes a Marketvendor " do
      vendor = create(:vendor)
      market = create(:market)
      market_vendor = market.market_vendors.create(vendor: vendor)
    
      expect(MarketVendor.last).to eq(market_vendor)
    
      delete "/api/v0/market_vendors/#{market_vendor.id}"
      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(MarketVendor.last).to_not eq(market_vendor)
      expect{MarketVendor.find(market_vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "returns a 404 status and error message when an invalid market_vendor id is passed in" do 
      delete "/api/v0/market_vendors/0987654321" 

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find MarketVendor with 'id'=0987654321")
    end
  end

end