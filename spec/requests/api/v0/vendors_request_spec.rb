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
    it "returns all vendor attributes for a specific vendor" do
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

    xit "returns a 404 status and error message when an invalid vendor id is passed in" do 
      get "/api/v0/vendors/0987654321" 
  
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
  
      #error handeling 
    end
  end

  describe "Vendor create" do
    it "creates a new vendor record when passed all attributes" do
      vendor_params = ({
                      name: "Tommy's Teas",
                      description: 'Delicious Teas',
                      contact_name: 'Tommy Tommerson',
                      contact_phone: '123-456-7890',
                      credit_accepted: true
                    })

      headers = {"CONTENT_TYPE" => "application/json"}
    
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last
    
      expect(response).to be_successful
      expect(response.status).to eq 201
      expect(created_vendor.name).to eq("Tommy's Teas")
      expect(created_vendor.description).to eq("Delicious Teas")
      expect(created_vendor.contact_name).to eq("Tommy Tommerson")
      expect(created_vendor.contact_phone).to eq("123-456-7890")
      expect(created_vendor.credit_accepted).to eq(true)
    end

    xit "returns a 404 status and error message when an all attributes are not passed in" do 
      vendor_params = ({
                      name: "Tommy's Teas",
                      description: 'Delicious Teas',
                      contact_name: 'Tommy Tommerson',
                      credit_accepted: true
                    })

      headers = {"CONTENT_TYPE" => "application/json"}
    
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last 
  
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
  
      #error handeling 
    end
  end

  describe "Vendor destroy" do
    it "deletes a vendor and all associated records" do
      vendor = create(:vendor)
      market = create(:market)
      market_vendor = market.market_vendors.create(vendor: vendor)
    
      expect(Vendor.last).to eq(vendor)
    
      delete "/api/v0/vendors/#{vendor.id}"
    
      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(Vendor.last).to_not eq(vendor)
      expect{Vendor.find(vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect{MarketVendor.find(market_vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    xit "returns a 404 status and error message when an invalid vendor id is passed in" do 
      delete "/api/v0/vendors/0987654321" 
  
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
  
      #error handeling 
    end
  end
end