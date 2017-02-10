# Main class
class TrainRoutesAnalitics
  DEFAULT_ROUTE_REGEX = /[A-E]+\d+/
  OUTPUT_FILE_NAME = 'out.txt'

  attr_reader :input_data

  def initialize(input_file_name, route_regexp = nil)
    @route_regexp = route_regexp
    @input_data = File.open(input_file_name) do |f|
      f.read.scan(route_mask)
    end
  end

  def route_mask
    @route_regexp || DEFAULT_ROUTE_REGEX
  end

end
