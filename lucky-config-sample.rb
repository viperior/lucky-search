class LuckyConfig
  attr_accessor :cse_api_key, :cse_search_id, :geocoding_api_key, :places_api_key

  def initialize
    # Insert your Google Custom Search Engine API key and search id below
    @cse_api_key = 'asdf'
    @cse_search_id = 'sdfg'

    # Insert your Google Maps Geocoding API key below
    @geocoding_api_key = 'dfgh'
    
    #Insert your Google Places API Web Service key below
    @places_api_key = 'fghj'
  end

end
