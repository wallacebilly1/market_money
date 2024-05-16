require "rails_helper"

RSpec.describe Atm do
  before(:each) do
    @atm_attr = {
      type: "atm",
      poi: {
        name: "ATM at gas station"
      },
      address: {
        freeformAddress: "31 East Santa Clara Street, San Jose, CA 95113"
      },
      position: {
        lat: "37.336651",
        lon: "-121.890117"
      },
      dist: "40.16466"
    }

    @atm = Atm.new(@atm_attr)
  end

  it "exists" do
    expect(@atm).to be_an Atm
    expect(@atm.type).to eq("atm")
    expect(@atm.name).to eq("ATM at gas station")
    expect(@atm.address).to eq("31 East Santa Clara Street, San Jose, CA 95113")
    expect(@atm.lat).to eq("37.336651")
    expect(@atm.lon).to eq("-121.890117")
    expect(@atm.distance).to eq("40.16466")
  end
end