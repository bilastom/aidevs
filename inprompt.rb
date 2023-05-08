require './completion'
require './task_tool'

# Using the task verification module from the API, retrieve the knowledge base for the task named "inprompt",
# and then answer the question located in the 'question' field.
# The base is too large to be used directly in your query.
# You must come up with any method for searching it based on the name of the person the question returned by the API refers to.
class Inprompt
  def initialize
    @task_tool = TaskTool.new('inprompt')
    @completion = Completion.new
  end

  def call
    @task = task_tool.fetch_task
    @input = task['input']
    @question = task['question']

    answer = completion.call(answer_prompt)
    puts "OpenAI answer: #{answer}"
    task_tool.send_answer(answer)
  end

  private

  attr_reader :completion, :input, :prompt, :question, :task_tool, :task

  def prompt
    "return Polish name from the sentence: #{question} Answer with one word"
  end

  def answer_prompt
    "Based on data: '#{filtered_input}'. Answer the question: '#{question}'"
  end

  def name
    @name ||= completion.call(prompt).gsub!(/\W+/, '')
  end

  def filtered_input
    input.filter { |x| x.include?(name) }.first
  end
end
