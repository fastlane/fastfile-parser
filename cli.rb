require_relative './parser2'
path = ARGV.shift
parser = Fastlane::MyParser.new(path: path)
puts "[-------]"
parser.print
