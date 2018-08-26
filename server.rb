require 'socket'

SO_REUSEPORT = 15
BACKLOG = 5

s = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
s.setsockopt(Socket::SOL_SOCKET, SO_REUSEPORT, 1)
s.bind(Addrinfo.tcp("0.0.0.0", 8080))
s.listen(BACKLOG)

puts "Listening... (pid: #{$$})"

while true
  conn, addr = s.accept
  data.recv
  msg = <<-EOS
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8
Server: rserver
Connection: close

OK, good
EOS
  conn.send(msg, 0)
  conn.close
end
