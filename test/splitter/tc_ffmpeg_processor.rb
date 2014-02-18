require "test/unit"
require_relative "../../app/splitter/ffmpeg_processor"
 
class TestFfmpegProcessor < Test::Unit::TestCase

  def setup
    @processor = FfmpegProcessor.new
  end
 
  def test_seconds_to_ffmpeg_time
    assert_equal("00:00:15.000", @processor.time_to_str(15))
    assert_equal("00:01:00.000", @processor.time_to_str(60))
    assert_equal("00:01:35.000", @processor.time_to_str(95))
    assert_equal("01:00:01.000", @processor.time_to_str(3601))
    assert_equal("01:00:01.666", @processor.time_to_str(3601.666))
  end
 
end