Gem::Specification.new do |s|
  s.name        = 'fastfile-parser'
  s.version     = '0.0.0'
  s.licenses    = ['MIT']
  s.summary     = "Convert the Fastfile to a JSON file https://fastlane.tools"
  s.description = ""
  s.authors     = ["Felix Krause"]
  s.email       = 'fastlane@krausefx.com'
  s.files       = ["lib/fastfile_parser.rb"]
  s.homepage    = 'https://github.com/fastlane/fastfile-parser'
  s.metadata    = { "source_code_uri" => "https://github.com/fastlane/fastfile-parser" }
  s.add_dependency 'parser', ">= 2.4.0.2", "< 2.5.0.0"
  s.add_dependency 'unparser', ">= 0.2.6", "< 1.0.0"
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
end
