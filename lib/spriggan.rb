require "beaneater"

class Spriggan
  def initialize(
    beanstalk_host: "127.0.0.1",
    beanstalk_port: 11300,
    module_name: "anonymous"
  )
    @beanstalk_host = beanstalk_host
    @beanstalk_port = beanstalk_port
    @beanstalk = Beaneater.new("#{@beanstalk_host}\:#{@beanstalk_port}")
    @module_name = module_name
  end #def

  # Logs a message to stdout, with flush to work with PM2
  def log(msg)
    $stdout.puts msg
    $stdout.flush
  end

  def seng_msg(msg)
    msg_str = msg.to_yaml
    msg64 = Base64.encode64(msg_str)
    return msg64
  end

  def open_msg(msg64)
    msg = Base64.decode64(msg64)
    obj = YAML.load(msg)
    return obj
  end

  def self.run
    @beanstalk.tubes.find(@module_name) # also creates the tube
    @beanstalk.tubes.watch!(@module_name)
    @core_threads.each { |thr| thr.join }
  end #def

  private #===========// PRIVATE METHODS //===========//

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
end
