require 'httparty'

module HttpCaller
  include HTTParty

  def self.make_get_request(url, headers = {})
    puts "Making GET to #{url}"
    get(url, headers: headers)
  end

  def self.make_post_request(url, body, headers = {})
    puts "Making POST to #{url} with body: #{body}"
    post(url, body: body, headers: headers)
  end
end
