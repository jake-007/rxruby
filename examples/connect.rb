require 'rx'

interval = Rx::Observable.interval(1)

source = interval
    .take(2)
    .do {|x| puts 'Side effect' }

def create_observer(tag)
  Rx::Observer.configure do |o|
    o.on_next { |x| puts 'Next: ' + tag + x.to_s }
    o.on_error { |err| puts 'Error: ' + err.to_s }
    o.on_completed { puts 'Completed' }
  end
end

published = source.publish

published.subscribe(create_observer('SourceA'))
published.subscribe(create_observer('SourceB'))

# Connect the source
connection = published.connect

# => Side effect
# => Next: SourceA0
# => Next: SourceB0
# => Side effect
# => Next: SourceA1
# => Next: SourceB1
# => Completed
# => Completed

while Thread.list.size > 1
  (Thread.list - [Thread.current]).each &:join
end
