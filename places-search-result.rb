class PlacesSearchResult

  attr_reader :has_photo, :photo_attribution_html, :photo_height, :photo_reference, :photo_width

  def initialize(api_endpoint)
    @api_endpoint = api_endpoint
    parse_results_from_json
  end
  
  def parse_results_from_json
    begin
      p "Parsing JSON string..."
      sleep 0.6
      response = HTTParty.get(@api_endpoint)
      results_json_object = response.parsed_response
      #results_json_object = JSON.parse(results_json_object)
      p "Status: #{results_json_object['status']}"
    rescue => e
      p 'Error occurred while parsing JSON data!'
      raise e
    else
      p 'Successfully parsed JSON data! Grabbing data from JSON object...'
      result = results_json_object['results'][0]
      
      if( result.nil? || result['photos'].nil? )
        p 'Warning - No photo found!'
        @has_photo = false
      else
        @has_photo = true
        photo = result['photos'][0]
        @photo_attribution_html = photo['html_attributions'][0]
        @photo_reference = photo['photo_reference']
        @photo_height = photo['height']
        @photo_width = photo['width']
      end
    end
  end

end
