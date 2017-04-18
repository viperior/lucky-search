require 'arrayfields'
require 'httparty'
require 'json'
require 'open-uri'
require 'pp'
require 'sqlite3'
require 'uri'
require_relative 'ballpark.rb'
require_relative 'ballpark-list.rb'
require_relative 'lucky-config.rb'
require_relative 'places-api-endpoint.rb'
require_relative 'places-search-result.rb'
require_relative 'sqlite3-session.rb'

def main

  p 'Lucky Search (Module: Fetch Photo)'
  sleep(0.5)

  # Get Lucky Search Configuration Settings
  lucky_config = LuckyConfig.new

  # Debug
  target_index_mode = false
  target_index = 4

  p 'Retrieving ballparks from database...'
  sleep(0.5)

  # Create and populate a ballpark list with only modern stadiums.
  ballpark_list = BallparkList.new
  condition = 'active_status = 1'
  ballpark_list.load_from_sqlite_db('mlbapp', 'ballparks', condition)

  ballpark_list.ballparks.each do |ballpark|
    sep = '- - - - - - - - - - - - - - - - - - - - -'
    p "Searching Google Places for a photo of #{ballpark.primary_name}..."

    # Create the Google Places API Endpoint
    places_api_endpoint = PlacesAPIEndpoint.new(lucky_config, ballpark)

    # Look up the ballpark using Google Places API
    ballpark_places_data = PlacesSearchResult.new(places_api_endpoint.uri)

    if( ballpark_places_data.has_photo )
       # Display the API data
      p "Places API Photo Data"
      p "Height: #{ballpark_places_data.photo_height}"
      p "Width: #{ballpark_places_data.photo_width}"
      p "Attribution HTML: #{ballpark_places_data.photo_attribution_html}"
      p "Photo Reference: #{ballpark_places_data.photo_reference}"

      # Build the photo url
      max_height = 800
      max_width = 800
      photo_url = 'https://maps.googleapis.com/maps/api/place/photo?key='
      photo_url += lucky_config.places_api_key + '&photoreference='
      photo_url += ballpark_places_data.photo_reference + '&maxheight='
      photo_url += max_height.to_s + '&maxwidth=' + max_width.to_s

      # Generage the image file name
      image_name = 'park' + ballpark.ballpark_db_id.to_s + '.jpg'
      image_directory = './img/'
      image_path = image_directory + image_name

      # Save the image to local storage
      sleep 0.8
      File.open(image_path, 'wb') do |fo|
        fo.write open(photo_url).read
      end

      # Save the photo attribution html to the local database.
      sleep 0.2
      ballpark.places_photo_attribution_html = ballpark_places_data.photo_attribution_html
      ballpark.places_photo_filename = image_name
    else
      p 'No photo result found!'
    end

    p sep
  end

  ballpark_list.save_places_photo_data_to_db('mlbapp', 'ballparks')

  p 'Thanks for using LuckySearch!'
  p

end

main
