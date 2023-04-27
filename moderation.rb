require './http_caller'

# Class that verifies if given prompt is disallowed by OpenAI
class Moderation
  URL = 'https://api.openai.com/v1/moderations'
  
  def initialize(api_key:)
    @api_key = api_key
  end

  def flagged?(input)
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{@api_key}"
    }

    body = { input: }.to_json
    response = HttpCaller.make_post_request(URL, body, headers)

    response.fetch('results')&.first['flagged']
  end
end
