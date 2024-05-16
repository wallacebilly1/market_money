class MarketSearchService
  attr_reader :search_params

  def initialize(search_params)
    @search_params = search_params
  end

  def valid?
    return true if (state_present? && city_present? && name_present?)
    return true if (state_present? && name_present?) || (state_present? && city_present?)
    return false if (city_present? && name_present?)
    return false if city_present?
    return true if state_present? || name_present?
  end

  def results
    markets = Market.all
    markets = markets.where("name ILIKE ?", "%#{search_params[:name]}%") if name_present?
    markets = markets.where("state ILIKE ?", "%#{search_params[:state]}%") if state_present?
    markets = markets.where("city ILIKE ?", "%#{search_params[:city]}%") if city_present?
    markets
  end

  private
  def city_present?
    search_params[:city].present?
  end

  def state_present?
    search_params[:state].present?
  end

  def name_present?
    search_params[:name].present?
  end
end