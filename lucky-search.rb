require 'csv'
require 'json'
require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'pp'
require 'rubygems'
require 'uri'
require_relative 'address.rb'
require_relative 'ballpark.rb'
require_relative 'ballpark-list.rb'
require_relative 'web-page.rb'
require_relative 'ballpark-web-page.rb'
require_relative 'geocoding-api-endpoint.rb'
require_relative 'lucky-config.rb'
require_relative 'lucky-uri.rb'
require_relative 'places-api-endpoint.rb'
require_relative 'query-term-list.rb'
require_relative 'search-api-endpoint.rb'
require_relative 'search-result.rb'
require_relative 'search-results-list.rb'
require_relative 'uri-parameter.rb'

# MLB-specific requirements
require_relative 'ballpark-web-page.rb'

def main

  p 'Lucky Search'

  # Get Lucky Search Configuration Settings
  lucky_config = LuckyConfig.new

  # Specify the filename of the search terms list
  search_terms_list = QueryTermList.new( 'search-terms.csv' )
  p "Loading search terms from #{search_terms_list.filename}..."
  
  p 'Building ballpark data collection...'
  
  ballpark_list = BallparkList.new
  
  search_terms_list.terms.each_with_index do |line, index|
    
    ballpark_name = line[0]
    
    current_ballpark = Ballpark.new
    current_ballpark.primary_name = ballpark_name
    
    p "Finding information about #{current_ballpark.primary_name}..."
    
    p 'Searching Google for the ballpark\'s web page...'
    
    cse_endpoint_uri = GoogleCSEEndpoint.new( lucky_config, current_ballpark ).uri
    search_results = SearchResultsList.new( 'uri', cse_endpoint_uri, 1 )
    
    p 'Results retrieved!'
    
    ballpark_search_result = search_results.results[0]
    current_ballpark.website = ballpark_search_result.link
    current_ballpark.home_team = ballpark_search_result.team_name
    
    p "It looks like #{current_ballpark.primary_name} is the home stadium of the #{current_ballpark.home_team}"
    p "Their website is: #{current_ballpark.website}"
    
    current_ballpark_website_object = BallparkWebPage.new( lucky_config, current_ballpark )
    
    if( !current_ballpark_website_object.entity_address.nil? )
      p "I identified the address for this ballpark as: #{current_ballpark_website_object.entity_address}"
      p 'Looking up the detailed address info from online sources...'
      
      current_ballpark_address_object = Address.new( lucky_config, current_ballpark_website_object )
      current_ballpark.city = current_ballpark_address_object.city
      current_ballpark.latitude = current_ballpark_address_object.latitude
      current_ballpark.longitude = current_ballpark_address_object.longitude
      current_ballpark.state = current_ballpark_address_object.state
      current_ballpark.street_address = current_ballpark_address_object.street_address
      current_ballpark.zip = current_ballpark_address_object.zipcode
      
      p "It looks like #{current_ballpark.primary_name} is located in #{current_ballpark.city}, #{current_ballpark.state}"
      p "Street address: #{current_ballpark.street_address}"
      p "Map coordinates: #{current_ballpark.latitude}, #{current_ballpark.longitude}"
    else
      p "I couldn't find the address of #{current_ballpark.primary_name} from MLB.com or Google Places."
    end
    
    ballpark_list.add_ballpark( current_ballpark )
    
    if( index == (search_terms_list.terms.length - 1) )
      p "Data for #{index + 1} ballparks has been collected!"
      sleep(2)
    else
      p "Taking a quick break..."
      sleep(1)
      p "Fetching the data for the next ballpark"
    end
    
  end
  
  save_filename = 'testing5.csv'
  p "Saving ballpark data to the file, #{save_filename}..."
  ballpark_list.save_as_csv( save_filename )
  
  p 'Thanks for using LuckySearch!'

end

main
