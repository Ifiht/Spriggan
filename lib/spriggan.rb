require "spriggan/check_conn"
require "spriggan/bean_msg"
require "beaneater"
require "json"

class Spriggan
  attr_accessor :core_threads, :beanstalk, :bean_msg
  # default handler for any messages received through
  # beanstalkd. Proc must be able to handle hash in
  # the bean_msg format.
  def initialize(
    beanstalk_host: "127.0.0.1",
    beanstalk_port: 11300,
    module_name: "core"
  )
    @core_threads = []
    @module_name = module_name
    @bean_msg = BeanMsg.new(@module_name)
    @beanstalk_host = beanstalk_host
    @beanstalk_port = beanstalk_port
    @beanstalk = Beaneater.new("#{@beanstalk_host}\:#{@beanstalk_port}")
  end #def

  # Logs a message to stdout, with flush to work with PM2
  def pm2_log(msg)
    $stdout.puts msg
    $stdout.flush
  end

  # Grabs the current process list from PM2, returns it as an array
  def pm2_procs
    proc_list = JSON.parse(%x(pm2 jlist))
    proc_names = Array.new
    proc_list.each { |e| proc_names << e["name"] }
    return proc_names
  end

  # Grabs all current tubes from beanstalkd
  def bean_tubes
    alltubes = Array.new
    @beanstalk.tubes.all.each do |t|
      alltubes << t.name
    end
    return alltubes
  end

  # Send a message to beanstalkd with a priority of 100 (default is 0,
  # which is also the highest pri) delay of 0, and ttr of 300.
  # This will auto-delete the job after 300 seconds.
  def send_msg(obj, tube)
    bean = @beanstalk.tubes[tube]
    hashstr = @bean_msg.wrap_msg(obj)
    bean.put hashstr, :pri => 100, :delay => 0, :ttr => 300
    pm2_log "Sent message: #{str}"
  end

  # blocks until a job is sent to the module's beanstalk tube, then
  # decodes it and returns a bean_msg formatted hash.
  def get_msg
    @beanstalk.tubes.watch!(@module_name)
    job = @beanstalk.tubes.reserve # this will block until a job is received
    msg_hash = @bean_msg.open_msg(job.body)
    pm2_log "Received job: #{msg_hash["msg"]}; from: #{msg_hash["from"]};"
    job.delete
    return msg_hash
  end

  # Adds the given block to the core_threads array, and puts it
  # immediately to sleep
  def add_thread(&block)
    puts "adding thread..."
    thr = Thread.new { block.call }
    @core_threads << thr
  end

  # Run all the threads, with a trap for signal interrupt from
  # PM2, and join in case of more than one thread.
  def run
    Signal.trap("INT") {
      i = 0
      core_threads.each { |t|
        pm2_log "killing core thread #{i}.."
        t.kill
        i += 1
      }
      pm2_log "Exiting gracefully."
      exit
    }
    @core_threads.each { |thr| thr.join }
    @core_threads = []
  end #def
end
