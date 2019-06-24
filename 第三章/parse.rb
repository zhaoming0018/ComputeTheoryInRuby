require './Rules.rb'
require './regular.rb'
require 'treetop' # 安装 gem install treetop
puts Treetop.load('pattern') # 对应simple.treetop
# parse_tree = SimpleParser.new.parse('(a(|b))*')
parse_tree = PatternParser.new.parse('(a(|b))*')
pattern = parse_tree.to_ast
puts pattern
puts pattern.matches?('abaab')
puts pattern.matches?('abba')
# statement = parse_tree.to_ast
# statement.evaluate({ x: Number.new(1) })
# puts statement.to_ruby