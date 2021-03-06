require_relative 'service_error'
require 'json'
require 'net/http'

module HttpJsonService # mix-in

  def get(method, *args)
    name = method.to_s
    json = http(name, args_hash(name, *args)) { |uri|
      Net::HTTP::Get.new(uri)
    }
    result(json, name)
  end

  def http(method, args)
    uri = URI.parse("http://#{hostname}:#{port}/" + method)
    http = Net::HTTP.new(uri.host, uri.port)
    request = yield uri.request_uri
    request.content_type = 'application/json'
    request.body = args.to_json
    response = http.request(request)
    JSON.parse(response.body)
  end

  def args_hash(method, *args)
    parameters = self.class.instance_method(method).parameters
    Hash[parameters.map.with_index { |parameter,index|
      [parameter[1], args[index]]
    }]
  end

  def result(json, name)
    fail_if(name, 'bad json') { json.class.name == 'Hash' }
    exception = json['exception']
    fail_if(name, pretty(exception)) { exception.nil? }
    fail_if(name, 'no key') { json.key?(name) }
    json[name]
  end

  def fail_if(name, message, &block)
    to_raise = ServiceError.new(self.class.name, name, message)
    fail to_raise unless block.call
  end

  def pretty(json)
    JSON.pretty_generate(json)
  end

end
