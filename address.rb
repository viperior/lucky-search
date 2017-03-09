class Address

  attr_reader :city, :latitude, :longitude, :route, :state, :street_address, :street_number, :textual_address, :zipcode

  def initialize(textural_address, geocoding_api_key, geocoding_api_options = [])
    @textual_address = textual_address
    @geocoding_api_key = geocoding_api_key
    @geocoding_api_options = geocoding_api_options
    @geocoding_api_data = geodata
    @geocoding_api_json = geodata_json
    @geocoding_json_address_components = address_components

    @city = find_address_component 'locality'
    @state = find_address_component 'administrative_area_level_1'
    @route = find_address_component 'route'
    @street_number = find_address_component 'street_number'
    @zipcode = find_address_component 'postal_code'

    @street_address = "#{@street_number} #{@route}"
    @latitude = coordinate 'latitude'
    @longitude = coordinate 'longitude'
  end

  def address_components
    return @geocoding_api_data['results']['address_components']
  end

  def coordinate axis
    coordinates = @geocoding_api_data['results']['geometry']['location']
    return axis == 'latitude' ? coordinates['lat'] : coordinates['lng']
  end

  def long_or_short name
    short_fields = ['administrative_area_level_1', 'route']
    return short_fields.include? name ? 'short_name' : 'long_name'
  end

  def geodata
    geocoding_api_uri = GeocodingAPIEndpoint.new( @geocoding_api_key, @textual_address, @geocoding_api_options )
    return open(geocoding_api_uri.uri).read
  end

  def geodata_json
    return JSON.parse @geocoding_api_data
  end

  def find_address_component name
    return @geocoding_json_address_components[ index_of_address_component name ][ long_or_short name ]
  end

  def index_of_address_component name
    @geocoding_json_address_components.each_with_index do |component, index|
      return index unless component['types'][0] != name
    end
  end

end
