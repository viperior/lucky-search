class SearchResult
  
  attr_accessor :link, :title
  
  def team_name
        pattern = /\|\s{1}\w{1,}\s{1}\w{1,}/
        title_text = @title
        match_data = title_text.match(pattern)
        team_section = match_data[0]
        team_name = team_section[ 2..(team_section.length - 1) ]
        
        return team_name.to_s
  end
  
end
