module SearchRouteAlgorithms
  # Dijkstra Algorithm implementation original source https://gist.github.com/mathieugagne/6556780
  module Dijkstra
    # Edge class implementation
    class Edge
      attr_accessor :src, :dst, :length
      def initialize(src, dst, length = 1)
        @src = src
        @dst = dst
        @length = length
      end
    end
    # Graph class implementation
    class Graph < Array
      attr_reader :edges

      def initialize
        @edges = []
      end

      def connect(src, dst, length = 1)
        raise ArgumentError, "No such vertex: #{src}" unless include?(src)
        raise ArgumentError, "No such vertex: #{dst}" unless include?(dst)
        @edges.push Edge.new(src, dst, length)
      end

      def neighbors(vertex)
        neighbors = []
        @edges.each do |edge|
          neighbors.push edge.dst if edge.src == vertex
        end
        neighbors.uniq
      end

      def length_between(src, dst)
        @edges.each do |edge|
          return edge.length if edge.src == src && edge.dst == dst
        end
        nil
      end

      def dijkstra(src, dst = nil)
        distances = {}
        previouses = {}
        each do |vertex|
          distances[vertex] = nil # Infinity
          previouses[vertex] = nil
        end
        distances[src] = 0
        vertices = clone
        until vertices.empty?
          nearest_vertex = vertices.inject do |a, b|
            next b unless distances[a]
            next a unless distances[b]
            next a if distances[a] < distances[b]
            b
          end
          break unless distances[nearest_vertex] # Infinity
          return distances[dst] if dst && nearest_vertex == dst

          neighbors = vertices.neighbors(nearest_vertex)
          neighbors.each do |vertex|
            alt = distances[nearest_vertex] +
                  vertices.length_between(nearest_vertex, vertex)
            if distances[vertex].nil? || alt < distances[vertex]
              distances[vertex] = alt
              previouses[vertices] = nearest_vertex
              # decrease-key v in Q # ???
            end
          end
          vertices.delete nearest_vertex
        end
        dst.nil? ? distances : dst
      end
    end
  end
end
