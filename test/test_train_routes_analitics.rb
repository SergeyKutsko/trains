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

  def test_process
    @object.process
    assert_equal true, File.exist?(TrainRoutesAnalitics::OUTPUT_FILE_NAME)
    File.delete(TrainRoutesAnalitics::OUTPUT_FILE_NAME)
  end

  # Output #1: 9
  def test_the_distance_of_the_route_A_B_C
    assert_equal 9, @object.length_of_route('A-B-C')
  end
  # Output #2: 5
  def test_the_distance_of_the_route_A_D
    assert_equal 5, @object.length_between('A', 'D')
  end
  # Output #3: 13
  def test_the_distance_of_the_route_A_D_C
    assert_equal 13, @object.length_of_route('A-D-C')
  end
  # Output #4: 22
  def test_the_distance_of_the_route_A_E_B_C_D
    assert_equal 22, @object.length_of_route('A-E-B-C-D')
  end
  # Output #5: NO SUCH ROUTE
  def test_the_distance_of_the_route_A_E_D
    assert_equal 'NO SUCH ROUTE', @object.length_of_route('A-E-D')
  end
  # Output #6: 2
  def test_trip_count_between_with_max_stops_C_C_3
    assert_equal 2, @object.all_trips_between_with_max_stops_count('C', 3)
  end
   # Output #7: 3
  def test_trip_count_between_with_max_stops_A_C_exact_4
    assert_equal 3, @object.all_trips_between_with_exact_stops_count('A-C', 4)
  end
  # Output #8: 9
  def test_the_length_of_the_shortest_route_A_C
    assert_equal 9, @object.shortest_route('A-C')
  end
  # Output #9: 9
  def test_the_length_of_the_shortest_route_B_B
    assert_equal 0, @object.shortest_route('B')['B']
  end
  # Output #10: 7
  def test_the_length_of_the_shortest_route_C_C
    assert_equal 7, @object.all_looped_path_less_than_count('C', 30)
  end
end
