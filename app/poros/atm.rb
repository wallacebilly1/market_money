class Atm
  attr_reader :id,
              :type,
              :name,
              :address,
              :lat,
              :lon,
              :distance

  def initialize(atm_data)
    @id = nil
    @type = "atm"
    @name = atm_data[:poi][:name]
    @address = atm_data[:address][:freeformAddress]
    @lat = atm_data[:position][:lat]
    @lon = atm_data[:position][:lon]
    @distance = atm_data[:dist]
  end
end