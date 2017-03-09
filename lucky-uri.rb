class LuckyURI

  def initialize(base, options)
    @base = base.to_s
    @options = options
  end

  def uri
    uri = @base

    if ( @options.length > 0 )
      uri += '?'

      @options.each_with_index do |option, index|
        uri += "#{option.key}=#{option.value}"

        if( @options.length > index )
          uri += '&'
        end
      end
    end

    return URI.parse( URI.encode( uri.to_s ) )
  end

end
