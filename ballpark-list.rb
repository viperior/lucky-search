class BallparkList

  attr_reader :ballparks

  def initialize
    @ballparks = []
  end
  
  def add_ballpark(ballpark_object)
    @ballparks.push(ballpark_object)
  end
  
  def save_as_csv(filename)
    CSV.open(filename, 'wb') do |csv|
      @ballparks.each do |ballpark|
        csv << ballpark.values
      end
    end
  end
  
end
