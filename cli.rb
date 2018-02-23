require_relative './fastfile_parser'

path = ARGV.shift
parser = Fastlane::FastfileParser.new(path: path)
puts "[-------]"
parser.print
