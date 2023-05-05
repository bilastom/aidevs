require './completion'
require './main'


class Inprompt
  def initialize(send_answer: false)
    @task_tool = TaskTool.new('inprompt')
    @completion = Completion.new
  end

  def call
    @task = task_tool.fetch_task
    @input = task['input']
    @question = task['question']

    answer = completion.call(answer_prompt)
    puts "OpenAI answer: #{answer}"
    task_tool.send_answer(answer) if send_answer
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
