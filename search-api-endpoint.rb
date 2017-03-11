class GoogleCSEEndpoint

  attr_reader :uri

  def initialize(config, entity)
    query = URI.parse( URI.encode( entity.primary_name ) ).to_s
    @uri = "https://www.googleapis.com/customsearch/v1?key=#{config.cse_api_key}&cx=#{config.cse_search_id}&q=#{query}"
  end

end
