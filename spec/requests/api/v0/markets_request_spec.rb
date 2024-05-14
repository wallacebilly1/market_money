require 'rails_helper'

describe "Markets API" do
  it "sends a list of markets" do
    create_list(:market, 4)

    get '/api/v0/markets'

    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)
    expect(markets[:data].count).to eq(4)
    
    markets.each do |market|
      # require 'pry'; binding.pry
      # for some reason it says that there is no key of id there but when you run pry it shows the id there. Also the other problem is that the vender count is all 0 which it shouldn't be that.  I have tried to comment out the  vendor serializer because i dont think we are supposed to need that but then that will make our test on line 12 to fail for some reason.  This might not be the best typed out but i can go over it again with you once we are back from lunch so it can make more sense on what i have done to try to make this code work. 
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(Integer)

      expect(market).to have_key(:name)
      expect(market[:name]).to be_an(String)

      expect(market).to have_key(:street)
      expect(market[:street]).to be_an(String)
      
      expect(market).to have_key(:city)
      expect(market[:city]).to be_an(String)
      
      expect(market).to have_key(:county)
      expect(market[:county]).to be_an(String)
      
      expect(market).to have_key(:state)
      expect(market[:state]).to be_an(String)
      
      expect(market).to have_key(:zip)
      expect(market[:zip]).to be_an(String)

      expect(market).to have_key(:lat)
      expect(market[:lat]).to be_an(String)

      expect(market).to have_key(:lon)
      expect(market[:lon]).to be_an(String)

      expect(market[:vender_count]).to be_an(Integer)
    end

  end
end