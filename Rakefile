require 'rubygems'
require 'bundler'
Bundler.setup

require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib'
end

desc 'Run tests'
task default: :test
