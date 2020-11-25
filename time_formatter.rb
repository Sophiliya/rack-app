class TimeFormatter
  FORMATS = { 
    'year' => '%Y', 
    'month' => '%m', 
    'day' => '%d', 
    'hour' => '%H', 
    'minute' => '%M', 
    'second' => '%S' 
}.freeze

  def initialize(formats)
    @formats = formats
    @valid_format = ''
    @unknown_formats = []
  end

  def call
    @formats.each do |format|
      if FORMATS[format]
        @valid_format += @valid_format.empty? ? FORMATS[format] : ('-' + FORMATS[format])
      else
        @unknown_formats << format
      end
    end
  end 

  def success?
    @unknown_formats.empty?
  end

  def error_message
    "Unknown time format #{@unknown_formats}"
  end

  def time_string
    Time.now.strftime(@valid_format)
  end
end
