require 'yaml'
require './http_caller'
require './lib/filter_accents'

# Class performs chat completion requests
# Configuration is loaded from ./config.yml
class Completion
  def initialize(config: {})
    @url = 'https://api.openai.com/v1/chat/completions'
    @config = YAML.load_file('config.yml')['openai_api'].transform_keys(&:to_sym)
    @config.merge(config)
  end

  def call(content)
    filtered_content = FilterAccents.for(content)
    response = HttpCaller.make_post_request(url, body(filtered_content), headers)

    total_tokens = response.parsed_response.dig('usage', 'total_tokens')
    puts "Used: #{total_tokens} tokens"

    response.parsed_response['choices'].first.dig('message', 'content')
  end

  private

  attr_reader :config, :url

  def body(content)
    {
      model: config[:model], 
      max_tokens: config[:max_tokens],
      temperature: config[:temperature],
      messages: [{ role: config[:role], content: }]
    }.to_json
  end

  def headers
    {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{config[:api_key]}"
    }
  end
end
