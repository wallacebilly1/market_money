require 'rails_helper'

describe "Vendors API" do
  before(:each) do
    @market_1 = create(:market)
    @vendor_1 = create(:vendor)
    @vendor_2 = create(:vendor)
    @vendor_3 = create(:vendor)
    @vendor_4 = create(:vendor)
    @mv_1_1 = @market_1.market_vendors.create(vendor: @vendor_1)
    @mv_1_2 = @market_1.market_vendors.create(vendor: @vendor_2)
    @mv_1_3 = @market_1.market_vendors.create(vendor: @vendor_3)
    @mv_1_4 = @market_1.market_vendors.create(vendor: @vendor_4)
  end
  
  describe "Vendor index" do
    it "sends a list of a market's vendors with all attributes for that vendor" do
      get "/api/v0/markets/#{@market_1}/vendors"
  
      expect(response).to be_successful
  
      vendors = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(vendors.count).to eq(4)
      expect(vendors).to be_an(Array)
      
      vendors.each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_an(String)
  
        expect(vendor[:attributes]).to have_key(:name)
        expect(vendor[:attributes][:name]).to be_an(String)
  
        expect(vendor[:attributes]).to have_key(:street)
        expect(vendor[:attributes][:street]).to be_an(String)
        
        expect(vendor[:attributes]).to have_key(:city)
        expect(vendor[:attributes][:city]).to be_an(String)
        
        expect(vendor[:attributes]).to have_key(:county)
        expect(vendor[:attributes][:county]).to be_an(String)
        
        expect(vendor[:attributes]).to have_key(:state)
        expect(vendor[:attributes][:state]).to be_an(String)
        
        expect(vendor[:attributes]).to have_key(:zip)
        expect(vendor[:attributes][:zip]).to be_an(String)
  
        expect(vendor[:attributes]).to have_key(:lat)
        expect(vendor[:attributes][:lat]).to be_an(String)
  
        expect(vendor[:attributes]).to have_key(:lon)
        expect(vendor[:attributes][:lon]).to be_an(String)
  
        expect(vendor[:attributes][:vendor_count]).to be_an(Integer)
      end
    end
  end

  describe "Vendor show" do
    it "returns all vendor attributes for a specific vendor" do
      get "/api/v0/markets/#{@market_1}/vendors/#{@vendor1}"

      #rest of test here.
    end
  end
end