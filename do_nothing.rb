Signal.trap(:TERM) do
  puts "receive TERM, I'm #{$$}"
  sleep 6
  puts "bye"
  exit
end

t = Thread.start do
  while true
    puts "hi, I'm #{$$}, ENV #{ENV["TEST"]}"
    sleep 3
  end
end

t.join
