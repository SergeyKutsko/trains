require 'minitest'
require 'minitest/autorun'
require_relative './test_helper'

# Test
class TrainRoutesAnaliticsTest < Minitest::Test
  def setup
    @object = TrainRoutesAnalitics.new('test_input.txt')
  end

  def test_default_route_regex
    assert_equal TrainRoutesAnalitics::DEFAULT_ROUTE_REGEX, /[A-E]+\d+/
  end

  def test_default_output_file
    assert_equal TrainRoutesAnalitics::OUTPUT_FILE_NAME, 'out.txt'
  end

end
