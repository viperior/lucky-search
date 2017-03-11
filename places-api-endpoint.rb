class PlacesAPIEndpoint

  attr_reader :uri

  def initialize(config, entity)
    query = URI.parse( URI.encode( entity.primary_name ) ).to_s
    @uri = "https://maps.googleapis.com/maps/api/place/textsearch/json?key=#{config.places_api_key}&query=#{query}"
  end

end
