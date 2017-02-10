require_relative './train_routes_analitics/search_route_algorithms.rb'
# Main class
class TrainRoutesAnalitics
  VERTEX_REGEX = '[A-E]{2}'.freeze
  DISTANCE_REGEX = '\d+'.freeze
  DEFAULT_ROUTE_REGEX = Regexp.new "#{VERTEX_REGEX}#{DISTANCE_REGEX}"
  OUTPUT_FILE_NAME = 'out.txt'.freeze
  NO_ROUTE_MESSAGE = 'NO SUCH ROUTE'.freeze

  include SearchRouteAlgorithms

  attr_reader :input_data, :graph

  def initialize(input_file_name, edge_regexp = nil)
    @graph = Dijkstra::Graph.new
    @distance_matrix = {}
    @edge_regexp = edge_regexp
    @input_data = File.open(input_file_name) do |f|
      text = f.read
      text.scan(route_mask)
    end

    build_graph
  end

  def length_between(v1, v2)
    graph.length_between v1, v2
  end

  def length_of_route(path)
    path = path_to_array(path)
    current_vertex = path.shift
    lengths = path.map do |next_vertex|
      length = length_between current_vertex, next_vertex
      current_vertex = next_vertex
      length
    end
    lengths.all? ? lengths.inject(&:+) : NO_ROUTE_MESSAGE
  end

  def all_trips_between_with_max_stops_count(vertex, max_stops)
    filter_paths(all_trips_between_with_max_stops(vertex, max_stops), vertex)
  end

  def all_trips_between_with_exact_stops_count(path, exact_stops)
    v1, v2 = *path_to_array(path)
    filter_paths(all_trips_between_with_max_stops(v1, exact_stops), v1, v2) do |a|
      a.select{ |i| i.length == exact_stops + 1 }
    end
  end

  def shortest_route(path)
    v1, v2 = *path_to_array(path)
    graph.dijkstra v1, v2
  end

  def all_looped_path_less_than_count(vertex, max)
    filter_paths(all_routes_from_less_than(vertex, max), vertex)
  end

  private

  def filter_paths(paths, v1, v2 = nil)
    v2 ||= v1
    result = paths.split(', ').map do |item|
      item[Regexp.new("#{v1}.+#{v2}")]
    end.compact.uniq
    result = yield(result) if block_given?
    result.count
  end

  def all_trips_between_with_max_stops(vertex, max_stops, stack = [])
    stack.push vertex
    graph.neighbors(vertex).map do |n|
      if (stops_left = max_stops - 1) >= 0
        all_trips_between_with_max_stops(n, stops_left, stack.dup)
      else
        stack.join
      end
    end.uniq.join(', ')
  end

  def path_to_array(path)
    path.split('-')
  end

  def all_routes_from_less_than(vertex, max, stack = [])
    stack.push vertex
    graph.neighbors(vertex).map do |n|
      if (l = max - length_between(vertex, n)) > 0
        all_routes_from_less_than(n, l, stack.dup)
      else
        stack.join
      end
    end.uniq.join(', ')
  end

  def build_graph
    input_data.each do |edge|
      v1, v2 = *edge.scan(/\p{Lu}/)
      w = edge[/\d+/].to_i
      graph.push v1
      graph.push v2
      graph.uniq!
      graph.connect v1, v2, w
    end
  end

  def route_mask
    @edge_regexp || DEFAULT_ROUTE_REGEX
  end
end
