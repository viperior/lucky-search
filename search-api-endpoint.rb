class GoogleCSEEndpoint

  attr_reader :uri

  def initialize(api_key, search_id, query)
    query = URI.parse( URI.encode( query ) ).to_s
    @uri = "https://www.googleapis.com/customsearch/v1?key=#{api_key}&cx=#{search_id}&q=#{query}"
  end

end
