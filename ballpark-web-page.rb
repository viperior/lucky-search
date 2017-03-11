class BallparkWebPage < WebPage
  
  attr_reader :content, :entity_address

  def initialize(config, entity)
    super
    @address_pattern = /\d{1,2}.{3,100}\d{5}/
    @places_json_data = nil
    @entity_address = get_entity_address
  end

  def get_entity_address
    accordion_content_object = @content.css( 'ul#accordion' )[0]
    
    if( !accordion_content_object.nil? )
      accordion_text = accordion_content_object.text
      match_data = accordion_text.match( @address_pattern )
    end
    
    if( defined? match_data && match_data.nil? )
      @places_json_data = places_api_data_json
      
      if( @places_json_data['status'] == 'OK' )
        return @places_json_data['results'][0]['formatted_address'].to_s
      else
        return nil
      end
    else
      return match_data[0].to_s
    end
  end
  
  def places_api_data_json
    begin
      p "Using Google Places API Web Service to get location data about #{@entity.primary_name}"
      places_api_uri = PlacesAPIEndpoint.new( @config, @entity ).uri
      places_api_data = open( places_api_uri ).read
    rescue
      p 'Error occurred while trying to read data from Google Places API!'
      places_api_data_json = nil
    else
      p 'Successfully read data from Google Places API!'
      places_api_data_json = JSON.parse( places_api_data )
    ensure
      return places_api_data_json
    end
  end
  
end
