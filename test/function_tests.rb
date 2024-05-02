require "spriggan"
require "test/unit"

class TestSprig < Test::Unit::TestCase
  def test_log
    sp = Spriggan.new
    o = sp.log("it was Jack")
    assert_equal(o, $stdout)
  end
end
