require_relative '../lib/train_routes_analitics'
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start { add_filter '/test/' }
end
