class BallparkList

  attr_reader :ballparks

  def initialize
    @ballparks = []
  end
  
  def add_ballpark(ballpark_object)
    @ballparks.push(ballpark_object)
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
