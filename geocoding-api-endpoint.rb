class GeocodingAPIEndpoint

  attr_reader :uri

  def initialize(config, entity)
    address = URI.parse( URI.encode( entity.entity_address ) ).to_s
    @uri = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{config.geocoding_api_key}"
  end

end
