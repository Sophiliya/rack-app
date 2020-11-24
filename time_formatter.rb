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
  end

  def call
    success? ? { time_string: time_string } : { error: error_message }
  end

  private 

  def success?
    @unknown_formats = @formats - FORMATS.keys

    @unknown_formats.any? ? false : true
  end

  def error_message
    "Unknown time format #{@unknown_formats}"
  end

  def time_string
    format = @formats.map { |f| FORMATS[f] }.join('-')
    Time.now.strftime(format)
  end
end
