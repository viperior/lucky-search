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
    begin
      p "Attempting to read the file, #{@resource}..."
      file = File.read @resource
    rescue
      p 'Error occurred while trying to read file!'
      file = nil
    else
      p 'Successfully read file!'
    ensure
      return file
    end
  end

  def get_json_from_uri
    begin
      p 'Getting search results from Google Custom Search Engine API using the endpoint:'
      p @resource
      buffer = open(@resource).read
    rescue
      p 'Error occurred while reading data from Google CSE API!'
      buffer = nil
    else
      p 'Successfully read data from Google CSE API!'
    ensure
      p 'Taking a quick break...'
      sleep(2)
      return buffer
    end
  end

  def parse_results_from_json
    begin
      p "Parsing JSON string..."
      search_results_json_object = JSON.parse @json
    rescue
      p 'Error occurred while parsing JSON data!'
      search_results = nil
    else
      p 'Successfully parsed JSON data! Grabbing search results from JSON object...'
      search_items = search_results_json_object['items']
      search_results = []

      [@limit, search_items.length].min.times do |i|
        search_result = SearchResult.new
        search_result.link = search_items[i]['link']
        search_result.title = search_items[i]['title']
        search_results.push search_result
      end
    ensure
      return search_results
    end
  end

  def process_json_resource
    if( @method == 'file' )
      return get_json_from_file
    else
      return get_json_from_uri
    end
  end

  def show_results
    @results.each do |result|
      p "Result: title = '#{result.title}', url = '#{result.link}'"
      p "Team name:"
      p "#{result.team_name}"
    end
  end

end
