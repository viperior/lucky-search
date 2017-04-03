class BallparkList

  attr_reader :ballparks

  def initialize
    @ballparks = []
  end
  
  def add_ballpark(ballpark_object)
    @ballparks.push(ballpark_object)
  end
  
  def load_from_sqlite_db(db_name, table_name, condition = '')
    begin
      # Establish database connection
      p 'Establishing database connection...'
      db = SQLite3DatabaseSession.new(db_name)
      
      # Prepare optional condition, if provided.
      if( !condition.empty? )
        condition = " WHERE #{condition}"
      end
      
      # Prepare sql query
      sql = "SELECT * FROM #{table_name}#{condition};"
      
      # Select the ballpark records
      db.execute_query(sql)
      result = db.result
      
      # Process the data from the database
      result.each_with_index do |row, index|
        current_ballpark = Ballpark.new
        current_ballpark.ballpark_db_id = row['park_id']
        current_ballpark.primary_name = row['primary_name']
        current_ballpark.alternate_names = row['alternate_names']
        current_ballpark.home_team = row['home_team']
        current_ballpark.league = row['league']
        current_ballpark.street_address = row['street_address']
        current_ballpark.city = row['city']
        current_ballpark.state = row['state']
        current_ballpark.zip = row['zip']
        current_ballpark.latitude = row['latitude']
        current_ballpark.longitude = row['longitude']
        current_ballpark.active_status = row['active_status']
        
        add_ballpark(current_ballpark)
      end
    rescue => e
      p 'An error occurred while loading the ballparks from the database!'
      raise e
      sleep (0.2)
    else
      p 'Ballparks were successfully loaded from the sqlite3 database.'
    end
  end
  
  def save_as_csv(filename)
    CSV.open(filename, 'wb') do |csv|
      @ballparks.each do |ballpark|
        csv << ballpark.values
      end
    end
  end
  
  def save_primary_names_to_db(db_name, table_name)
    begin
      p 'Establishing database connection...'
      db = SQLite3DatabaseSession.new(db_name)
      p 'Database connection established...'
      
      c = 0
      
      @ballparks.each do |ballpark|
        # Sanitize the ballpark name
        park_name = ballpark.primary_name.gsub(/(\')+/, "''")
        
        # Check if the ballpark is already in the database
        db.execute_query("SELECT COUNT(*) FROM ballparks WHERE primary_name = '#{park_name}'")
        r = db.result
        count = nil
        
        r.each_with_index do |row, index|
          if( index == 0 )
            count = row[0]
          end
        end
        
        is_in_db = count > 0
        
        if( !is_in_db )
          c += 1
          db.execute_query("INSERT INTO #{table_name} (primary_name) VALUES ('#{park_name}')")
        else
          p "#{park_name} is already in the database. Skipping..."
          sleep (0.1)
        end
      end
    rescue => e
      p 'Error occurred while attempting to add ballpark names to database!'
      p e.backtrace
      raise
    else
      p "#{c} ballpark#{c > 1 ? 's' : ''} added to database!"
    end
  end
  
end
