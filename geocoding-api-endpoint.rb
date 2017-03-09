class GeocodingAPIEndpoint

  attr_reader :uri

  def initialize(api_key, address, options = [])
    @api_key = URIParameter.new('key', api_key)
    @address = URIParameter.new('address', address)
    @options = [@address, @api_key]
    @options += options
    @uri = LuckyURI.new('https://maps.googleapis.com/maps/api/geocode/json', @options).uri
  end

end
