require "test/unit"
require_relative "../../app/teaseclip/processor"

class MyMovieProcessor
  def short_file (file, start_at, short_file_name)
  end

  def keyframes (short_file_name)
end

class TestTeaseClipProcessor < Test::Unit::TestCase

  def setup
    @tcp = TeaseClipProcessor.new
  end
 
 
end