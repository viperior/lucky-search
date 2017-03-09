class BallparkWebPage < WebPage

  def initialize(uri)
    super
    @address_pattern = /\d{1,2}.+\d{5}/
  end

  def address
    accordion_text = @content.css('ul#accordion')[0].text
    match_data = accordion_text.match(@address_pattern)
    address = match_data[0]
    return address.to_s
  end
  
end
