# Task tool
A simple Ruby script for authorizing, fetching exercises and sending solutions from the [aidevs.pl](https://www.aidevs.pl/) course.

The script can be executed in irb

```
irb -r ./main.rb
```

Example usage:
```ruby
obj = TaskTool.new('34534665-dfdg-665-436fg-5346dgffg', 'helloapi')
obj.fetch_token
obj.fetch_task
obj.send_answer 'lorem ipsum'
```