require "base64"
require "yaml"

# Class to handle serialization of Ruby objects,
# tracking of senders & recipients, and finally
# very basic obfuscation of sent data in base64
#
# Message Format:
#   msg_hash = {
#      "to" => <destination beanstalkd tube>
#      "from" => <tube owned by calling process>
#      "msg" => <any valid ruby object, coded as a yaml string>
#   }
#
class BeanMsg
  def initialize(origin)
    @origin = origin
  end

  # Returns the string to send via beanstalkd
  def wrap_msg(obj, dest)
    msg = obj.to_yaml
    msg64 = Base64.encode64(msg)
    msg_hash = {
      "to" => dest,
      "from" => @origin,
      "msg" => msg64
    }
    return msg_hash.to_yaml
  end

  # Returns a hash with decoded msg string
  def open_msg(msg_yaml)
    msg_hash64 = YAML.load(msg_yaml)
    msg_hash = {
      "to" => msg_hash64["to"],
      "from" => msg_hash64["from"],
      "msg" => YAML.load(Base64.decode64(msg_hash64["msg"]))
    }
    return msg_hash
  end
end
