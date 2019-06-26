require './PDA.rb'
require './NPDA.rb'

# rule = PDARule.new(1, '(', 2, '$', ['b', '$'])
# configuration = PDAConfiguration.new(1, Stack.new(['$']))

# puts rule.push_characters
# rule.follow(configuration)

rulebook = DPDARulebook.new([
    PDARule.new(1, '(', 2, '$', ['b', '$']),
    PDARule.new(2, '(', 2, 'b', ['b', 'b']),
    PDARule.new(2, ')', 2, 'b', []),
    PDARule.new(2, nil, 1, '$', ['$'])
])

# configuration = rulebook.next_configuration(configuration, '(')
# puts configuration
# configuration = rulebook.next_configuration(configuration, '(')
# puts configuration
# configuration = rulebook.next_configuration(configuration, ')')
# puts configuration

# dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook)

# dpda.read_string('(()')
# puts dpda.accepting?

# configuration = PDAConfiguration.new(2, Stack.new(['$']))
# puts rulebook.follow_free_moves(configuration)

# dpda_design = DPDADesign.new(1, '$', [1], rulebook)
# puts dpda_design.accepts?('(((((((((())))))))))')
# puts dpda_design.accepts?('()))(((((')
# puts dpda_design.accepts?('()(())((()))()')

rulebook = NPDARulebook.new([
    PDARule.new(1, 'a', 1, '$', ['a', '$']),
    PDARule.new(1, 'a', 1, 'a', ['a', 'a']),
    PDARule.new(1, 'a', 1, 'b', ['a', 'b']),
    PDARule.new(1, 'b', 1, '$', ['b', '$']),
    PDARule.new(1, 'b', 1, 'a', ['b', 'a']),
    PDARule.new(1, 'b', 1, 'b', ['b', 'b']),
    PDARule.new(1, nil, 2, '$', ['$']),
    PDARule.new(1, nil, 2, 'a', ['a']),
    PDARule.new(1, nil, 2, 'b', ['b']),
    PDARule.new(2, 'a', 2, 'a', []),
    PDARule.new(2, 'b', 2, 'b', []),
    PDARule.new(2, nil, 3, '$', ['$'])
])

configuration = PDAConfiguration.new(1, Stack.new(['$']))
puts configuration
npda = NPDA.new(Set[configuration], [3], rulebook)
puts npda.accepting?
puts npda.current_configurations
npda.read_string('abb')
puts npda.accepting?
npda.read_string('a')
puts npda.accepting?

npda_design = NPDADesign.new(1, '$', [3], rulebook)
puts npda_design.accepts?('abba')
puts npda_design.accepts?('babbbbab')
puts npda_design.accepts?('abb')