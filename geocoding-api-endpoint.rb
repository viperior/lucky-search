class GeocodingAPIEndpoint

  attr_reader :uri

  def initialize(address, api_key)
    #@api_key = URIParameter.new('key', api_key)
    #@address = URIParameter.new('address', address)
    #@options = []
    #@options.push(@address)
    #@options.push(@api_key)
    #@uri = LuckyURI.new('https://maps.googleapis.com/maps/api/geocode/json', @options).uri
    address = URI.parse( URI.encode( address ) ).to_s
    pp address
    @uri = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{api_key}"
    pp @uri
  end

end
