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
    path = path.split('-')
    current_vertex = path.shift
    lengths = path.map do |next_vertex|
      length = graph.length_between current_vertex, next_vertex
      current_vertex = next_vertex
      length
    end
    lengths.all? ? lengths.inject(&:+) : NO_ROUTE_MESSAGE
  end

  private

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
