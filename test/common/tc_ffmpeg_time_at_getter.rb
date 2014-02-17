require "test/unit"
require_relative "../../app/common/ffmpeg_time_at_getter"
 
class TestFfmpegTimeAtGetter < Test::Unit::TestCase

  def setup
    @time_at_getter = FfmpegTimeAtGetter.new
  end
 
  def test_seconds_convert
    assert_equal(59, @time_at_getter.seconds_from_str("59"))
    assert_equal(61, @time_at_getter.seconds_from_str("1:1"))
    assert_equal(61, @time_at_getter.seconds_from_str("1:01"))
    assert_equal(61, @time_at_getter.seconds_from_str("01:01"))
    assert_equal(659, @time_at_getter.seconds_from_str("10:59"))
    assert_equal(4259, @time_at_getter.seconds_from_str("1:10:59"))
  end

end