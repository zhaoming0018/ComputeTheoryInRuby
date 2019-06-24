require './PDA.rb'

rule = PDARule.new(1, '(', 2, '$', ['b', '$'])
configuration = PDAConfiguration.new(1, Stack.new(['$']))

# puts rule.push_characters
# rule.follow(configuration)

rulebook = DPDARulebook.new([
    PDARule.new(1, '(', 2, '$', ['b', '$']),
    PDARule.new(2, '(', 2, 'b', ['b', 'b']),
    PDARule.new(2, ')', 2, 'b', []),
    PDARule.new(2, nil, 1, '$', ['$'])
])

configuration = rulebook.next_configuration(configuration, '(')
puts configuration
configuration = rulebook.next_configuration(configuration, '(')
puts configuration
configuration = rulebook.next_configuration(configuration, ')')
puts configuration