class Ballpark

    attr_accessor :active_status, :alternate_names, :ballpark_db_id, :city, :home_team, :latitude, :league, :longitude, :primary_name, :state, :street_address, :website, :zip
    
    def initialize
        @ballpark = []
    end
    
    def add_value(value)
        if( value.nil? )
            value = ''
        end
        
        @ballpark.push(value)
    end
    
    def values
        if( @ballpark.empty? )
            add_value(@primary_name)
            add_value(@alternate_names)
            add_value(@home_team)
            add_value(@league)
            add_value(@street_address)
            add_value(@city)
            add_value(@state)
            add_value(@zip)
            add_value(@latitude)
            add_value(@longitude)
            add_value(@active_status)
        end
            
        return @ballpark
    end
    
end
