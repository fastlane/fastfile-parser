require_relative './lib/fastfile_parser'

path = ARGV.shift
parser = Fastlane::FastfileParser.new(path: path)
puts "[-------]"
parser.print
puts "----"
parser.available_lanes
