require 'json'
require 'yaml'
require './http_caller'

# Simple class responsible for authorizing, fething exercises and sending solutions from the aidevs.pl course
# 
# Example usage:
#   obj = TaskTool.new('helloapi')
#   obj.fetch_token
#   obj.fetch_task
#   obj.send_answer 'lorem ipsum'
class TaskTool
  URL = 'https://zadania.aidevs.pl'

  def initialize(task_name)
    @api_key = YAML.load_file('config.yml')['aidevs'].transform_keys(&:to_sym)[:api_key]
    @task_name = task_name
  end

  def fetch_token
    url = "#{URL}/token/#{@task_name}"
    body = { apikey: @api_key }.to_json
    response = HttpCaller.make_post_request(url, body)
    puts response

    @token = response['token'] if response['code'] == 0
  end

  def fetch_task
    fetch_token if not_exists?('token')

    url = "#{URL}/task/#{@token}"
    response = HttpCaller.make_get_request(url).parsed_response
    puts response

    @task = response if response['code'] == 0
  end

  def send_answer(answer)
    return if not_exists?('task')

    url = "#{URL}/answer/#{@token}"
    body = { answer: }.to_json

    response =  HttpCaller.make_post_request(url, body).parsed_response
    puts response
  end

  private

  def not_exists?(variable)
    unless self.instance_variable_defined?("@#{variable}")
      puts "Please fetch #{variable} first!"

      return true
    end

    false
  end
end
