require "timeout"
require "socket"

# Checks a port with a default timeout of
# 2 seconds, if the TCP port is open returns true,
# else for all other reasons should return false
def port_open?(ip, port)
  Timeout::timeout(2) do
    begin
      TCPSocket.new(ip, port).close
      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
      false
    rescue Timeout::Error
      false
    end #begin
  end #do
end #def
