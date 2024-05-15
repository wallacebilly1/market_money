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
      get "/api/v0/markets/#{@market_1.id}/vendors"
  
      expect(response).to be_successful
  
      vendors = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(vendors.count).to eq(4)
      expect(vendors).to be_an(Array)
      
      vendors.each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_an(String)
  
        expect(vendor[:attributes]).to have_key(:name)
        expect(vendor[:attributes][:name]).to be_an(String)
  
        expect(vendor[:attributes]).to have_key(:description)
        expect(vendor[:attributes][:description]).to be_an(String)
        
        expect(vendor[:attributes]).to have_key(:contact_name)
        expect(vendor[:attributes][:contact_name]).to be_an(String)
        
        expect(vendor[:attributes]).to have_key(:contact_phone)
        expect(vendor[:attributes][:contact_phone]).to be_an(String)
        
        expect(vendor[:attributes]).to have_key(:credit_accepted)
        expect(vendor[:attributes][:credit_accepted]).to be_in([true, false])
      end
    end

    xit "returns a 404 status and error message when an invalid market id is passed in" do
      get "/api/v0/markets/123123123123123/vendors"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      # further tests on error message
    end
  end

  describe "Vendor show" do
    xit "returns all vendor attributes for a specific vendor" do
      get "/api/v0/vendors/#{@vendor_1.id}"

      #rest of test here.
    end
  end

  describe '#get one vendor' do
    it 'gets a single vendor' do

      get "/api/v0/vendors/#{@vendor_1.id}" 
      vendor = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_an(String)

      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes][:name]).to be_an(String)

      expect(vendor[:attributes]).to have_key(:description)
      expect(vendor[:attributes][:description]).to be_an(String)
      
      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes][:contact_name]).to be_an(String)
      
      expect(vendor[:attributes]).to have_key(:contact_phone)
      expect(vendor[:attributes][:contact_phone]).to be_an(String)
      
      expect(vendor[:attributes]).to have_key(:credit_accepted)
      expect(vendor[:attributes][:credit_accepted]).to be_in([true, false])
    end


    xit "sad path, when vendor id is invalid" do 

      get "/api/v0/vendors/0987654321" 

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      #error handeling 
    end
  end
end