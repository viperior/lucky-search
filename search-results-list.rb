class SearchResultsList
  attr_reader :results

  def initialize(method, resource, limit = 5)
    @method = method
    @resource = resource
    @limit = limit
    @json = process_json_resource
    @results = parse_results_from_json
  end

  def get_json_from_file
    return File.read @resource
  end

  def get_json_from_uri
    buffer = open(@resource).read
    return buffer
  end

  def parse_results_from_json
    search_results_json_object = JSON.parse @json
    search_items = search_results_json_object['items']
    search_results = []

    [@limit, search_items.length].min.times do |i|
      search_result = SearchResult.new
      search_result.link = search_items[i]['link']
      search_result.title = search_items[i]['title']
      search_results.push search_result
    end

    return search_results
  end

  def process_json_resource
    if( @method == 'file' )
      return get_json_from_file
    else
      return get_json_from_uri
    end
  end
  
  def save_results(filename)
    
  end

  def show_results
    @results.each do |result|
      p "Result: title = '#{result.title}', url = '#{result.link}'"
      p "Team name:"
      p "#{result.team_name}"
    end
  end

end
