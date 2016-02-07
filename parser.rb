require 'pry'
require 'json'

class Parser
  attr_accessor :path
  attr_accessor :content
  attr_accessor :tree

  def load(path: nil)
    self.path = path
    self.content = File.read(path)
    self.tree = {}

    eval(self.content, parsing_binding)

    puts "-------"
    puts JSON.pretty_generate(self.tree)
    puts "-------"
  end

  def parsing_binding
    binding
  end


  #####################################################
  # @!group DSL
  #####################################################

  def lane(lane_name, &block)
    description = @current_description
    platform = :ios # TODO

    self.tree[platform] ||= {}
    self.tree[platform][lane_name] = {
      description: description,
      actions: []
    }

    block.call

    @current_description = []
  end

  def desc(str)
    @current_description ||= []
    @current_description << str
  end

  def method_missing(method_sym, *arguments, &_block)
    platform = :ios # TODO
    current_lane = self.tree[platform].values.last
    current_lane[:actions] << {
      action: method_sym,
      parameters: arguments.first
    }
  end
end

Parser.new.load(path: "./examples/Fastfile1")
# Parser.new.load(path: "./examples/Fastfile2")

# Target Format
# {
#   "ios": {
#     "beta": {
#       "description": "My description",
#       "actions": [
#         {
#           "action": "gym",
#           "parameters": {
#             "scheme": "Example"
#         }
#       ]
#     }
#   }
# }
