class GoogleCSEEndpoint

  attr_reader :uri

  def initialize(api_key, search_id, query, options = [])
    @api_key = URIParameter.new('key', api_key)
    @search_id = URIParameter.new('cx', search_id)
    @query = URIParameter.new('q', query)
    @options = [@api_key, @search_id, @query]
    @options += options
    @uri = LuckyURI.new('https://www.googleapis.com/customsearch/v1', @options)
  end

end
