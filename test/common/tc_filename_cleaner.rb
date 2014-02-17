require "test/unit"
require_relative "../../app/common/filename_cleaner"
 
class TestFilenameCleaner < Test::Unit::TestCase

  def setup
    @cleaner = FilenameCleaner.new
  end
 
  def test_strip_metadata
    assert_equal("fu.bar", @cleaner.strip_metadata("fu.bar__Scene 1. Brumm, Nasse.mp4"))
  end

  def test_strip_extension
    assert_equal("fu.bar", @cleaner.strip_ext("fu.bar.mp4"))
  end

 
end