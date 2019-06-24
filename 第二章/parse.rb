require './require_all.rb'
require 'treetop' # 安装 gem install treetop
Treetop.load('simple') # 对应simple.treetop
parse_tree = SimpleParser.new.parse('while (x < 5) { x = x * 3 }')
statement = parse_tree.to_ast
statement.evaluate({ x: Number.new(1) })
puts statement.to_ruby