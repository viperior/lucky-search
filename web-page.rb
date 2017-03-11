class WebPage
  
  attr_reader :content

  def initialize(config, entity)
    @config = config
    @entity = entity
    @content = get_content
  end
  
  def get_content
    begin
      p 'Opening the following website with Nokogiri:'
      p @entity.website
      content = Nokogiri::HTML( open( @entity.website ) )
    rescue
      p 'Error occurred when trying to read the website with Nokogiri!'
      content = nil
    else
      p 'Successfully read website with Nokogiri!'
    ensure
      p 'Taking a quick break...'
      sleep(2)
      return content
    end
  end

  def title
    if( !@content.nil? )
      return @content.css('title')
    else
      p 'Cannot get the title of the web page, because there was an error reading the page content!'
      return nil
    end
  end

end
