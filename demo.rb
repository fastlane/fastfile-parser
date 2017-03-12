require './parser'

Fastlane::Parser.new(path: "./examples/Fastfile1").print
Fastlane::Parser.new(path: "./examples/Fastfile2").print
