require './completion'
require './task_tool'

# Task content:
# Write a blog post (in Polish) about making Margherita pizza. The task in the API is called "blogger".
# You will receive a list of 4 chapters that must appear in the post as input.
class Blogger
  def initialize
    @task_tool = TaskTool.new('blogger')
    @completion = Completion.new
  end

  def call
    @task = task_tool.fetch_task
    answer = completion.call(prompt).split("\n\n")

    task_tool.send_answer(answer)
  end

  private

  attr_reader :completion, :task, :task_tool

  def prompt
    "#{task['msg']} in polish language. Write two sentences for each bullet.\n".tap do |p|
      task['blog'].each { |x| p << "- #{x}\n" }
    end
  end
end
