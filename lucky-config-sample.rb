class LuckyConfig
  attr_accessor :cse_api_key, :cse_search_id, :geocoding_api_key

  def initialize
    # Insert your Google Custom Search Engine API key and search id below
    @cse_api_key = 'asdf'
    @cse_search_id = 'qwer'

    # Insert your Google Maps Geocoding API key below
    @geocoding_api_key = 'zxcv'
  end

end
