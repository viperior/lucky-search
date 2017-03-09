class QueryTermList
  attr_reader :filename, :terms

  def initialize(filename)
    @filename = filename
    @terms = []

    get_terms_from_file
  end

  def get_terms_from_file
    CSV.foreach(@filename) do |term|
      @terms.push(term)
    end
  end

  def list_terms
    @terms.each do |term|
      p term
    end
  end

end
