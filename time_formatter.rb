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
    unknown_formats = @formats.select { |format| !FORMATS.keys.include?(format) }
    return "Unknown time format #{unknown_formats}" if unknown_formats.any?

    format = @formats.map { |f| FORMATS[f] }.join('-')
    Time.now.strftime(format)
  end
end
