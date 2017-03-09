class WebPage
  attr_reader :content

  def initialize(uri)
    @content = Nokogiri::HTML( open( uri ) )
  end

  def title
    return @content.css('title')
  end

end
