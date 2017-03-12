require 'pry'
require 'json'

# Parse a Fastfile and convert it to JSON data
module Fastlane
  class Parser
    attr_accessor :path
    attr_accessor :content
    attr_accessor :tree

    def initialize(path: nil)
      self.path = path
      self.content = File.read(path)
      self.tree = {}

      eval(self.content, parsing_binding)
    end

    def parsing_binding
      binding
    end

    def print
      STDOUT.puts "-------"
      STDOUT.puts JSON.pretty_generate(self.tree)
      STDOUT.puts "-------"
    end

    #####################################################
    # @!group DSL
    #####################################################

    def platform(platform_name, &block)
      @current_platform = platform_name
      block.call
      @current_platform = nil
    end

    def lane(lane_name, &block)
      description = @current_description
      @current_lane = lane_name

      self.tree[@current_platform] ||= {}
      self.tree[@current_platform][@current_lane] = {
        description: description,
        actions: []
      }

      block.call

      @current_description = []
      @current_lane = nil
    end

    def desc(str)
      @current_description ||= []
      @current_description << str
    end

    def before_all
      @current_lane = :_before_all_block_
      yield
      @current_lane = nil
    end

    def after_all
      @current_lane = :_after_all_block_
      yield
      @current_lane = nil
    end

    def error
      @current_lane = :_error_block_
      yield
      @current_lane = nil
    end

    def method_missing(method_sym, *arguments, &_block)
      self.tree[@current_platform] ||= {}
      current_lane = self.tree[@current_platform][@current_lane] ||= {}
      current_lane[:actions] ||= []
      current_lane[:actions] << {
        action: method_sym,
        parameters: arguments.first || {}
      }
    end

    def puts(str)
      method_missing(:puts, str)
    end

    def say(value)
      method_missing(:say, str)
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
