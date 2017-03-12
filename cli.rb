require_relative './parser'
path = ARGV.shift
Fastlane::Parser.new(path: path).print
