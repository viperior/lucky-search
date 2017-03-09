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
  search_terms_list = QueryTermList.new('search-terms.csv')
  p "Loading search terms from #{search_terms_list.filename}..."

  # Show results from file
  #p 'Showing results from file...'
  #search_results = SearchResultsList.new('file', 'sample-results.json', 1)
  #search_results.show_results
  
  # query = search_terms_list.terms[8][0] # Works
  query = search_terms_list.terms[5][0] # Works
  cse_endpoint = GoogleCSEEndpoint.new(lucky_config.cse_api_key, lucky_config.cse_search_id, query)
  search_results = SearchResultsList.new('uri', cse_endpoint.uri, 1)
  
  current_ballpark = Ballpark.new
  current_ballpark.primary_name = query
  
  ballpark_search_result = search_results.results[0]
  current_ballpark.website = ballpark_search_result.link
  current_ballpark.home_team = ballpark_search_result.team_name
  
  current_ballpark_website_object = BallparkWebPage.new( current_ballpark.website )
  
  if( !current_ballpark_website_object.address.empty? )
    current_ballpark_address_object = Address.new( current_ballpark_website_object.address, lucky_config.geocoding_api_key )
    current_ballpark.city = current_ballpark_address_object.city
    current_ballpark.latitude = current_ballpark_address_object.latitude
    current_ballpark.longitude = current_ballpark_address_object.longitude
    current_ballpark.state = current_ballpark_address_object.state
    current_ballpark.street_address = current_ballpark_address_object.street_address
    current_ballpark.zip = current_ballpark_address_object.zipcode
  end
  
  ballpark_list = BallparkList.new
  ballpark_list.add_ballpark( current_ballpark )
  ballpark_list.save_as_csv('testing1.csv')

  # Start fetching results
  #search_terms_list.terms.each do |query|
    #p "Getting search results for the query: '#{query}'..."

    # Set up the Google Custom Search Engine API endpoint
    #cse_endpoint = GoogleCSEEndpoint.new(lucky_config.cse_api_key, lucky_config.cse_search_id, query)

    # Perform the search
    #search_results = SearchResultsList.new('file', 'sample-results.json', 1)
    #search_results.show_results

  #end

  # Show content of a web page
  #p 'Showing some specific website content...'
  #web_page = BallparkWebPage.new('http://arizona.diamondbacks.mlb.com/ari/ballpark/')
  #web_page = BallparkWebPage.new('http://cleveland.indians.mlb.com/cle/ballpark/')
  #p web_page.title
  #p web_page.address

  # Test geocoding
  #p "api key = #{lucky_config.geocoding_api_key}, textual address = #{web_page.address}"
  #test_address = Address.new( web_page.address, lucky_config.geocoding_api_key )

end

main
