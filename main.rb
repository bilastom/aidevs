require 'httparty'
require 'json'

# Simple class responsible for authorizing, fething exercises and sending solutions from the aidevs.pl course
# 
# Example usage:
#   obj = TaskTool.new('34534665-dfdg-665-436fg-5346dgffg', 'helloapi')
#   obj.fetch_token
#   obj.fetch_task
#   obj.send_answer 'lorem ipsum'
class TaskTool
  URL = 'https://zadania.aidevs.pl'

  def initialize(api_key, task_name)
    @api_key = api_key
    @task_name = task_name
  end

  def fetch_token
    url = "#{URL}/token/#{@task_name}"
    body = { apikey: @api_key }.to_json
    response = make_post(url, body)
    puts response

    @token = response['token'] if response['code'] == 0
  end

  def fetch_task
    return if not_exists?('token')

    url = "#{URL}/task/#{@token}"
    response = make_get(url)
    puts response

    @task = response['msg'] if response['code'] == 0
  end

  def send_answer(answer)
    return if not_exists?('task')

    url = "#{URL}/answer/#{@token}"
    body = { answer: }.to_json

    response = make_post(url, body)
    puts response
  end

  private

  def make_get(url)
    puts "Making GET to #{url}"
    HTTParty.get(url).parsed_response
  end

  def make_post(url, body)
    puts "Making POST to #{url} with body: #{body}"
    HTTParty.post(url, body: body).parsed_response
  end

  def not_exists?(variable)
    unless self.instance_variable_defined?("@#{variable}")
      puts "Please fetch #{variable} first!"

      return true
    end

    false
  end
end