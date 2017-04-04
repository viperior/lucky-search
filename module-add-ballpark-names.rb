require 'csv'
require 'pp'
require 'sqlite3'
require_relative 'ballpark.rb'
require_relative 'ballpark-list.rb'
require_relative 'query-term-list.rb'
require_relative 'sqlite3-session.rb'

def main

  p 'Lucky Search (Module: Add Ballpark Names)'
  
  # Debug
  target_index_mode = false
  target_index = 0

  # Specify the filename of the search terms list
  search_terms_list = QueryTermList.new( 'search-terms.csv' )
  p "Loading search terms from #{search_terms_list.filename}..."
  
  p 'Building ballpark data collection...'
  
  ballpark_list = BallparkList.new
  
  search_terms_list.terms.each_with_index do |line, index|
    
    if( index == target_index || !target_index_mode )  # debug
    
      ballpark_name = line[0]
      
      current_ballpark = Ballpark.new
      current_ballpark.primary_name = ballpark_name
      
      ballpark_list.add_ballpark( current_ballpark )
      
      if( index == (search_terms_list.terms.length - 1) )
        p "#{index + 1} ballparks have been processed!"
      end
    
    end #debug
    
  end
  
  db_name = 'mlbapp'
  table_name = 'ballparks'
  p
  p "Saving ballpark data to the database, #{db_name}..."
  p
  ballpark_list.save_primary_names_to_db(db_name, table_name)
  
  p 'Thanks for using LuckySearch!'
  p

end

main
