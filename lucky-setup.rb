# Run this once to set up the sqlite3 database for LuckySearch.

require 'pp'
require 'sqlite3'
require_relative('sqlite3-field.rb')
require_relative('sqlite3-session.rb')
require_relative('sqlite3-table-schema.rb')

def lucky_setup
  
  sqlite_session = SQLite3DatabaseSession.new('mlbapp')
  sqlite_session.create_db
  
  # Define the ballparks table structure
  raw_field_data = [
    ['park_id', 'INTEGER', true],
    ['primary_name', 'TEXT'],
    ['alternate_names', 'TEXT'],
    ['home_team', 'TEXT'],
    ['league', 'TEXT'],
    ['street_address', 'TEXT'],
    ['city', 'TEXT'],
    ['state', 'TEXT'],
    ['zip', 'TEXT'],
    ['latitude', 'REAL'],
    ['longitude', 'REAL'],
    ['active_status', 'BOOLEAN'],
    ['mlb_web_page_url', 'TEXT'],
    ['mlb_web_physical_address', 'TEXT'],
    ['places_formatted_address', 'TEXT'],
    ['places_latitude', 'REAL'],
    ['places_longitude', 'REAL'],
    ['places_photo_reference', 'TEXT'],
    ['places_photo_attribution_html', 'TEXT'],
    ['places_photo_filename', 'TEXT']
  ]
  
  # Build and execute the table creation query.
  ballparks_table_schema = SQLite3TableSchema.new('ballparks')
  ballparks_table_schema.parse_raw_table_data(raw_field_data)
  query = ballparks_table_schema.table_creation_query
  sqlite_session.execute_query(query)
  
end

lucky_setup
