class Address

  attr_reader :city, :latitude, :longitude, :route, :state, :street_address, :street_number, :textual_address, :zipcode

  def initialize( config, entity )
    @config = config
    @entity = entity
    
    @json_data = geocoding_api_data_json

    @city = find_address_component('locality')
    @state = find_address_component('administrative_area_level_1')
    @route = find_address_component('route')
    @street_number = find_address_component('street_number')
    @zipcode = find_address_component('postal_code')

    @street_address = format_street_address
    @latitude = coordinate('latitude')
    @longitude = coordinate('longitude')
  end

  def address_components
    if( !@json_data.nil? )
      return @json_data['results'][0]['address_components']
    else
      return nil
    end
  end

  def coordinate(axis)
    coordinates = @json_data['results'][0]['geometry']['location']
    return axis == 'latitude' ? coordinates['lat'] : coordinates['lng']
  end
  
  def format_street_address
    if( !@street_number.empty? && !@route.empty? )
      return "#{@street_number} #{@route}"
    else
      return "#{@street_number}#{@route}"
    end
  end

  def long_or_short(name)
    short_fields = ['administrative_area_level_1', 'route']
    
    if( short_fields.include?name )
      return 'short_name'
    else
      return 'long_name'
    end
  end

  def geocoding_api_data_json
    p "Using Google Geocoding API to get data on the address: #{@entity.entity_address}"
    geocoding_api_endpoint_uri = GeocodingAPIEndpoint.new( @config, @entity ).uri
    
    begin
      geocoding_api_data = open( geocoding_api_endpoint_uri ).read
      geocoding_api_data_json = JSON.parse( geocoding_api_data )
      p 'Taking a quick break...'
      sleep(2)
    rescue
      p 'Error while getting geocoding data.'
      return nil
    else
      return geocoding_api_data_json
    end
  end

  def find_address_component(name)
    component_index = index_of_address_component(name)
    
    if( !component_index.nil? )
      return address_components[ component_index ][ long_or_short(name) ]
    else
      return ''
    end
  end

  def index_of_address_component(name)
    if( !address_components.nil? )
      address_components.each_with_index do |component, index|
        if( component['types'][0].to_s == name )
          return index
        else
          return nil
        end
      end
    else
      return nil
    end
  end

end
