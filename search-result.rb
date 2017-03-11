class SearchResult
  
  attr_accessor :link, :title
  
  def team_name
        pattern = /\|\s+.+/
        title_text = @title
        match_data = title_text.match(pattern)
        
        if( !match_data.nil? )
          team_section = match_data[0]
          team_name = team_section[ 2..(team_section.length - 1) ].to_s
        else
          team_name = ''
        end
        
        return team_name
  end
  
end
