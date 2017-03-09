class Address

  attr_reader :city, :latitude, :longitude, :route, :state, :street_address, :street_number, :textual_address, :zipcode

  def initialize(textual_address, geocoding_api_key)
    @textual_address = textual_address
    @geocoding_api_key = geocoding_api_key
    @json_data = geocoding_api_data_json

    @city = find_address_component('locality')
    @state = find_address_component('administrative_area_level_1')
    @route = find_address_component('route')
    @street_number = find_address_component('street_number')
    @zipcode = find_address_component('postal_code')

    @street_address = "#{@street_number} #{@route}"
    @latitude = coordinate('latitude')
    @longitude = coordinate('longitude')
  end

  def address_components
    return @json_data['results'][0]['address_components']
  end

  def coordinate(axis)
    coordinates = @json_data['results'][0]['geometry']['location']
    return axis == 'latitude' ? coordinates['lat'] : coordinates['lng']
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
    geocoding_api_endpoint = GeocodingAPIEndpoint.new( @textual_address, @geocoding_api_key )
    geocoding_api_endpoint_uri = geocoding_api_endpoint.uri
    geocoding_api_data = open( geocoding_api_endpoint_uri ).read
    geocoding_api_data_json = JSON.parse( geocoding_api_data )
    return geocoding_api_data_json
  end

  def find_address_component(name)
    return address_components[ index_of_address_component(name) ][ long_or_short(name) ]
  end

  def index_of_address_component(name)
    address_components.each_with_index do |component, index|
      if( component['types'][0].to_s == name )
        return index
      end
    end
  end

end
