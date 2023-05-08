require './completion'
require './task_tool'
require 'json'

class Scraper
  def initialize
    @task_tool = TaskTool.new('scraper')
    @completion = Completion.new
  end

  def call
    @task = task_tool.fetch_task

    response = HttpCaller.make_get_request(task['input'], user_agent_header)
    input = response.parsed_response

    prompt = "#{task['msg']}. #{task['question']} ### Data: #{input}"
    answer = completion.call(prompt)
    
    task_tool.send_answer(answer)
  end

  private

  attr_reader :completion, :task, :task_tool

  def user_agent_header
    { 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3' }
  end
end
