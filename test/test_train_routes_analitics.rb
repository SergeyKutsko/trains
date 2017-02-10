require 'minitest'
require 'minitest/autorun'
require_relative './test_helper'

# Test
class TrainRoutesAnaliticsTest < Minitest::Test
  def setup
    @object = TrainRoutesAnalitics.new('test_input.txt')
  end

  def test_default_route_regex
    assert_equal /[A-E]{2}\d+/, TrainRoutesAnalitics::DEFAULT_ROUTE_REGEX
  end

  def test_default_output_file
    assert_equal 'out.txt', TrainRoutesAnalitics::OUTPUT_FILE_NAME
  end

  def test_graph_edges_count
    assert_equal 9, @object.graph.edges.count
  end

  def test_graph_vertex_count
    assert_equal 5, @object.graph.count
  end

  def test_the_distance_of_the_route_A_B_C
    assert_equal 9, @object.length_of_route('A-B-C')
  end

  def test_the_distance_of_the_route_A_D
    assert_equal 5, @object.length_between('A', 'D')
  end

  def test_the_distance_of_the_route_A_D_C
    assert_equal 13, @object.length_of_route('A-D-C')
  end

  def test_the_distance_of_the_route_A_E_B_C_D
    assert_equal 22, @object.length_of_route('A-E-B-C-D')
  end

  def test_the_distance_of_the_route_A_E_D
    assert_equal 'NO SUCH ROUTE', @object.length_of_route('A-E-D')
  end
end
