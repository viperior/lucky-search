require 'pp'
require 'sqlite3'
require_relative 'ballpark.rb'
require_relative 'ballpark-list.rb'
require_relative 'sqlite3-session.rb'

def main

  p 'Lucky Search (Module: Add MLB Data)'
  sleep(0.5)
  
  # Debug
  target_index_mode = true
  target_index = 4
  
  p 'Retrieving ballparks from database...'
  sleep(0.5)
  
  # Read the ballparks from the database
  db_session = SQLite3DatabaseSession.new('mlbapp')
  db_session.execute_query('SELECT (SELECT COUNT() FROM ballparks) as count, * FROM ballparks;')
  #select (select count() from XXX) as count, * from XXX;
  result = db_session.result
  
  # Construct a ballpark list object to store the data
  ballpark_list = BallparkList.new
  
  # Create a ballpark object for each database record, and populate its data
  index = 0
  while( record = result.next ) do
  #result.each_with_index do |record, index|
    if( index == target_index || !target_index_mode )  # debug
    
      pp record
    
      # Set up a new ballpark object
      current_ballpark = Ballpark.new
      
      # Extract the data
      # code...
      
      # Add the ballpark to the list
      #ballpark_list.add_ballpark(current_ballpark)
      
      #if( index == (record['count'] - 1) )
      #  p "#{index + 1} ballparks have been processed!"
      #end
    
    end #debug
    
    index += 1
  end
  
  # Create a ballpark list to store all of the ballpark objects
  # code...
  
  # For each ballpark, try to get its MLB.com data
  # code...
  
  # For each ballpark where data was successfully retrieved, add that data
  #  back to its corresponding database record.
  db_name = 'mlbapp'
  table_name = 'ballparks'
  p
  p "Saving ballpark data to the #{table_name} table database, #{db_name}..."
  p
  # code that saves the data back to the db....
  
  p 'Thanks for using LuckySearch!'
  p

end

main
