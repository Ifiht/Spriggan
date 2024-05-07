require "spriggan"
require "test/unit"

class TestSprig < Test::Unit::TestCase
  def test_initialization
    sp = Spriggan.new
    o = sp.log("it was Jack")
    assert_equal(o, $stdout)
  end

  def test_messages
    i = 5
    sp = Spriggan.new(module_name: "test_messages")
    sp.seng_msg(i, "test_messages")
    msg_hash = sp.get_msg
    assert_equal("test_messages", msg_hash["to"])
    assert_equal("test_messages", msg_hash["from"])
    assert_equal(i, msg_hash["msg"])
  end

  def run_one_thread
    sp = Spriggan.new
    i = 2
    sp.add_thread {
      i+=1
    }
    sp.run
    assert_equal(i, 3)
  end

  def run_two_threads
    sp = Spriggan.new
    i = 1
    sp.add_thread {
      i+=1
    }
    sp.add_thread {
      i+=3
    }
    sp.run
    assert_equal(i, 5)
  end
end
