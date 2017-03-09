class GeocodingAPIEndpoint

  attr_reader :uri

  def initialize(address, api_key)
    address = URI.parse( URI.encode( address ) ).to_s
    @uri = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{api_key}"
  end

end
