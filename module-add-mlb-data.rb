require 'arrayfields'
require 'json'
require 'pp'
require 'sqlite3'
require 'uri'
require_relative 'ballpark.rb'
require_relative 'ballpark-list.rb'
require_relative 'web-page.rb'
require_relative 'ballpark-web-page.rb'
require_relative 'lucky-config.rb'
require_relative 'search-api-endpoint.rb'
require_relative 'search-result.rb'
require_relative 'search-results-list.rb'
require_relative 'sqlite3-session.rb'

def main

  p 'Lucky Search (Module: Add MLB Data)'
  sleep(0.5)
  
  # Get Lucky Search Configuration Settings
  lucky_config = LuckyConfig.new
  
  # Debug
  target_index_mode = true
  target_index = 4
  
  p 'Retrieving ballparks from database...'
  sleep(0.5)
  
  # Read the ballparks from the database
  db_session = SQLite3DatabaseSession.new('mlbapp')
  db_session.execute_query('SELECT (SELECT COUNT() FROM ballparks) as count, * FROM ballparks;')
  
  #db_session.results_as_hash = true
  result = db_session.result
  
  # Construct a ballpark list object to store the data
  ballpark_list = BallparkList.new
  
  # Create a ballpark object for each database record, and populate its data
  result_count = nil
  
  result.each_with_index do |row, index|
    if( index == target_index || !target_index_mode )  # debug
      if( index == 0 || ( target_index > 0 && index == target_index ) )
        result_count = row['count']
      end
    
      # Set up a new ballpark object
      current_ballpark = Ballpark.new
      
      # Extract the data
      current_ballpark.primary_name = row['primary_name']
      
      p "Finding information about #{current_ballpark.primary_name}..."
      
      p 'Searching Google for the ballpark\'s web page...'
      
      # Search the ballpark's website for information
      cse_endpoint_uri = GoogleCSEEndpoint.new( lucky_config, current_ballpark ).uri
      search_results = SearchResultsList.new( 'uri', cse_endpoint_uri, 1 )
      
      p 'Results retrieved!'
      
      ballpark_search_result = search_results.results[0]
      current_ballpark.website = ballpark_search_result.link
      current_ballpark.home_team = ballpark_search_result.team_name
      
      p "It looks like #{current_ballpark.primary_name} is the home stadium of the #{current_ballpark.home_team}"
      p "Their website is: #{current_ballpark.website}\n"
      
      current_ballpark_website_object = BallparkWebPage.new( lucky_config, current_ballpark )
      
      if( !current_ballpark_website_object.entity_address.nil? )
        p "I identified the address for this ballpark as: #{current_ballpark_website_object.entity_address}\n"
        p 'Looking up the detailed address info from online sources...'
        
        current_ballpark_address_object = Address.new( lucky_config, current_ballpark_website_object )
        current_ballpark.city = current_ballpark_address_object.city
        current_ballpark.latitude = current_ballpark_address_object.latitude
        current_ballpark.longitude = current_ballpark_address_object.longitude
        current_ballpark.state = current_ballpark_address_object.state
        current_ballpark.street_address = current_ballpark_address_object.street_address
        current_ballpark.zip = current_ballpark_address_object.zipcode
        
        current_ballpark_address_object.show_address_data
        
        p "It looks like #{current_ballpark.primary_name} is located in #{current_ballpark.city}, #{current_ballpark.state}"
        p "Street address: #{current_ballpark.street_address}"
        p "Map coordinates: #{current_ballpark.latitude}, #{current_ballpark.longitude}"
      else
        p "I couldn't find the address of #{current_ballpark.primary_name} from MLB.com or Google Places."
      end
      
      # Add the ballpark to the list
      ballpark_list.add_ballpark(current_ballpark)
      
      if( index == result_count - 1 || ( target_index > 0 && index == target_index ) )
        p "#{index + 1} ballparks have been processed!"
      end
    end #debug
  end
  
  # For each ballpark, try to get its MLB.com data
  # code...
  
  # For each ballpark where data was successfully retrieved, add that data
  #  back to its corresponding database record.
  # code...
  
  # Test code
  pp ballpark_list.ballparks[target_index]
  
  p 'Thanks for using LuckySearch!'
  p

end

main
