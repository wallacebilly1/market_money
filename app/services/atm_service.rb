class AtmService
  def conn
    conn = Faraday.new(url: "https://api.tomtom.com/search/2/") do |faraday|
      faraday.params["key"] = Rails.application.credentials.tomtom[:key]
    end
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def get_results(lat, lon)
    get_url("nearbySearch/.json?lat=#{lat}&lon=#{lon}&limit=5&categorySet=7397&view=Unified&relatedPois=off")
  end
end