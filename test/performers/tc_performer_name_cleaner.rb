require "test/unit"
require_relative "../../app/performers/performer_name_cleaner"
 
class TestPerformerNameCleaner < Test::Unit::TestCase

  def setup
    @acn = PerformerNameCleaner.new
  end
 
  def test_strip_leading_space
    assert_equal("fu", @acn.clean(" fu"))
  end

  def test_convert_comma_separated_names_to_underscores
    assert_equal("fu_bar_foo.fii", @acn.clean("fu,bar, foo.fii"))
  end

  def test_convert_spaces_to_dots
    assert_equal("fu.bar.foo.fii", @acn.clean("fu bar  foo.fii"))
  end

  def test_flatten_multiple_dots
    assert_equal("fu.bar.fii", @acn.clean("fu..bar...fii"))
  end
 
 
end