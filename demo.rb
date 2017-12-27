require './fastfile_parser'

Fastlane::FastfileParser.new(path: "./examples/Fastfile1").print
Fastlane::FastfileParser.new(path: "./examples/Fastfile2").print
