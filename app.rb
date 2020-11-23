require 'rack'
require_relative 'time_formatter'

class App
  
  def call(env)
    req = Rack::Request.new(env)

    case req.path_info
    when '/time'
      time_request_handler(req)
    else
      make_response("Not found", 404)
    end
  end

  private 

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def make_response(message, status)
    [status, headers, [message]]
  end

  def time_request_handler(req)
    return make_response('Method Not Allowed', 405) unless req.get?
    return make_response('Parameter format is missing', 422) unless req.query_string.match?(/^format=(\S+)/) 

    formats = time_formats(req.query_string)
    make_response(formatted_time(formats), 200)
  end

  def time_formats(query_string)
    params = query_string.split('=')
    params.last.split('%2C')
  end

  def formatted_time(formats)
    TimeFormatter.new(formats).call
  end
end
