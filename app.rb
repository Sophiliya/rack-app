require 'rack'
require_relative 'time_formatter'

class App
  
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

    result(params.last.split('%2C'))
  end

  def result(formats)
    { status: 200, body: [TimeFormatter.new(formats).call] }
  end
end
