# EXEC_COMMAND = "bundle exec ruby do_nothing.rb"
EXEC_COMMAND = "bundle exec ruby server.rb"

puts "Start master #{$$}"

def process_exists?(pid)
  Process.kill(0, pid.to_i)
  true
rescue Error::SCRCH # no such process
  false
rescue Error::EPERM # process exists, no permission
  true
end

child_pid = Process.fork
if child_pid
  puts "master waiting child: #{child_pid}"

  Signal.trap(:USR1) do
    new_child_pid = Process.fork
    if new_child_pid
      puts "master waiting child: #{new_child_pid} and kill old #{child_pid}"
      retry_limit = 3
      while !process_exists?(new_child_pid)
        puts "waiting new worker"
        sleep 1

        retry_limit -= 1
        if retry_limit < 0
          puts "Failed to Launch new worker..."
          exit 1
        end
      end
      Process.kill("TERM", child_pid)
      child_pid = new_child_pid
    else
      puts "exec child"
      exec(ENV, EXEC_COMMAND)
    end
  end

  Process.waitall
else
  exec(ENV, EXEC_COMMAND)
end
