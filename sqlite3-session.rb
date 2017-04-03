class SQLite3DatabaseSession
  # Represents a SQLite3 session for a single database. Create the database,
  # execute queries, and fetch data.
  
  attr_reader :columns, :result, :rows
  
  def initialize(db_name)
    @db_name = db_name
  end
  
  def create_db
    # Creates a new database.
    begin
      # Create a new database.
      db = SQLite3::Database.new(@db_name)
    rescue SQLite3::Exception => e
      # Display the error message upon error.
      p "Exception occurred"
      p e
    ensure
      # Make sure to close the database.
      db.close if db
    end
  end
  
  def execute_query(query)
    # Executes a query and returns the result.
    begin
      # Open the database
      db = SQLite3::Database.open(@db_name)
      
      # Prepare the SQL statement
      sql_statement = db.prepare(query)
      
      # Execute the statement and store the result.
      @result = sql_statement.execute
      
      #columns, *rows = db.execute2( "select * from test" )
      #@columns, *@rows = db.execute2(query)
    rescue SQLite3::Exception => e
      # Display the error message upon error.
      p "Exception occurred"
      p e
    end
  end
  
end
