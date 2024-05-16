class AtmFacade
  def initialize(market_id)
    @market_id = market_id
  end

  def nearest_atms
    service = AtmService.new

    market = Market.find(@market_id)
    lat = market.lat
    lon = market.lon
    
    json = service.get_results(lat, lon)

    atms = json[:results].map do |atm_data|
      Atm.new(atm_data)
    end
  end
end