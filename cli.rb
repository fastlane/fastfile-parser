require_relative './parser'

# Bootstrap Fastlane
require "fastlane"
Fastlane.load_actions

path = ARGV.shift

fl_parser = Fastlane::FastfileParser.new(content: File.read(File.expand_path(path)), filepath: path, name: "Fastfile", platforms: ["ios", "android"])

puts "Linting:"
table = fl_parser.analyze
puts table

puts "JSON"

puts fl_parser.json
