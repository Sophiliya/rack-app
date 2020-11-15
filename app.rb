require 'rack'

class App
  FORMATS = { 
    'year' => '%Y', 
    'month' => '%m', 
    'day' => '%d', 
    'hour' => '%H', 
    'minute' => '%M', 
    'second' => '%S' 
}.freeze

  def call(env)
    response = body(
      method: env['REQUEST_METHOD'], 
      path: env['REQUEST_PATH'], 
      query_string: env['QUERY_STRING']
    )

    [ response[:status], headers, response[:body] ]
  end

  private 

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body(method:, path:, query_string:)
    return { status: 405, body: ['Method Not Allowed'] } if method != 'GET'
    return { status: 404, body: ['Not found'] } if path != '/time'

    params = query_string.length > 0 ? query_string.split('=') : []
    return { status: 422, body: ['Parameter format is missing'] } if params.first != 'format' or params.count < 2

    formats = params.last.split('%2C')
    unknown_formats = formats.select { |format| !FORMATS.keys.include?(format) }
    return { status: 400, body: ["Unknown time format #{unknown_formats}"] } if unknown_formats.any?

    get_time?(formats)
  end

  def get_time?(formats)
    format = formats.map { |f| FORMATS[f] }.join('-')
    { status: 200, body: [Time.now.strftime(format)] }
  end
end
