require 'json'
require 'parser'
require 'parser/current'
require 'pry'
require 'unparser'


# opt-in to most recent AST format:
# Parser::Builders::Default.emit_lambda = true
# Parser::Builders::Default.emit_procarg0 = true

# Parse a Fastfile and convert it to JSON data
module Fastlane
  class MyParser
    attr_accessor :path
    attr_accessor :content
    attr_accessor :tree
    attr_accessor :raw_tree

    def initialize(path: nil)
      self.path = path
      self.content = File.read(path)
      self.tree = {}
      self.raw_tree = ::Parser::CurrentRuby.parse(self.content)
      @current_description = []

      self.parse_children(self.raw_tree)

      require 'pry'; binding.pry
      puts "done"
      self.print
    end

    def parse_children(node)
      node.children.each do |current_node|
        parse_node(current_node)
      end
    end

    def parse_node(current_node)
      if current_node.type == :send # method
        method_name = current_node.children[1]
        parameters = current_node.children[2].children if current_node.children[2]

        if parameters && parameters.first && parameters.first.kind_of?(Parser::AST::Node)
          new_parameters = {}
          parameters.each do |current_parameter|
            if current_parameter.type == :pair
              new_parameters[current_parameter.children[0].children.last] = current_parameter.children[1].children.last
            end
          end
          parameters = new_parameters
        elsif parameters
          parameters = parameters.first
        end

        if method_name == :desc
          @current_description << parameters
        else
          access_current_node[:actions] << {
            action: method_name,
            parameters: parameters
          }
        end
      elsif current_node.type == :block # lane/platform
        method_name = current_node.children[0].children[1]
        parameters = current_node.children[1]
        block_node = current_node.children[2]

        if method_name == :before_all
          @current_lane = :_before_all_block_
          parse_children(block_node)
          @current_lane = nil
        elsif method_name == :lane
          lane_name = current_node.children[0].children[2].children.last

          @current_lane = lane_name
          access_current_node[:description] = @current_description
          @current_description = []
          parse_children(block_node)
          @current_lane = nil
        elsif method_name == :platform
          platform_name = current_node.children[0].children[2].children.last
          @current_platform = platform_name
          # require 'pry'; binding.pry
          # parse_children(block_node)# if block_node.type == :block
          #parse_node(block_node) if block_node.type == :begin # this is different for nested blocks with no methods inbetween
          @current_platform = nil
        else
          access_current_node[:actions] << {
            advancedCode: Unparser.unparse(current_node)
          }
        end
      else
        access_current_node[:actions] << {
          advancedCode: Unparser.unparse(current_node)
        }
      end
    end

    def access_current_node
      self.tree[@current_platform] ||= {}
      self.tree[@current_platform][@current_lane] ||= {
        description: [],
        actions: []
      }
      return self.tree[@current_platform][@current_lane]
    end

    def print
      STDOUT.puts JSON.pretty_generate(self.tree)      
    end
  end
end

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
