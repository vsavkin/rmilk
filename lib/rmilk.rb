$:.unshift File.dirname(__FILE__)

require 'rmilk/rmilk_runner.rb'
include ConsoleRtm


ARGV[0] = 'rmilk -l Home'

query = ARGV.join(' ')

runner = RmilkRunner.new
runner.init_environment
runner.auth
runner.init_storage
runner.init_ui
runner.process(query)

