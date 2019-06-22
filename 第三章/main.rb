require './Rules.rb'
require 'set'

# rulebook = DFARuleBook.new([
#     FARule.new(1, 'a', 2), FARule.new(1, 'b', 1),
#     FARule.new(2, 'a', 2), FARule.new(2, 'b', 3),
#     FARule.new(3, 'a', 3), FARule.new(3, 'b', 3)
# ])

# dfa = DFA.new(1, [3], rulebook);
# puts dfa.accepting?

# dfa.read_string('baaab')
# puts dfa.accepting?

# dfa.read_character('b');
# puts dfa.accepting?

# 3.times do dfa.read_character('a') end
# puts dfa.accepting?

# dfa.read_character('b')
# puts dfa.accepting?

# dfa_design = DFADesign.new(1, [3], rulebook)
# puts dfa_design.accepts?('a')
# puts dfa_design.accepts?('baa')
# puts dfa_design.accepts?('baba')

# rulebook = NFARulebook.new([
#     FARule.new(1, 'a', 1), FARule.new(1, 'b', 1), FARule.new(1, 'b', 2),
#     FARule.new(2, 'a', 3), FARule.new(2, 'b', 3),
#     FARule.new(3, 'a', 4), FARule.new(3, 'b', 4)
# ])

# puts rulebook.next_states(Set[1], 'b')
# puts rulebook.next_states(Set[1, 2], 'a')
# puts rulebook.next_states(Set[1, 3], 'b')

# puts NFA.new(Set[1], [4], rulebook).accepting?
# puts NFA.new(Set[1, 2, 4], [4], rulebook).accepting?

# nfa = NFA.new(Set[1], [4], rulebook);
# puts nfa.accepting?
# nfa.read_string('bbbbb')
# puts nfa.accepting?

# nfa_design = NFADesign.new(1, [4], rulebook)
# puts nfa_design.accepts?('bab')
# puts nfa_design.accepts?('bbbbb')
# puts nfa_design.accepts?('bbabb')

rulebook = NFARulebook.new([
    FARule.new(1, nil, 2), FARule.new(1, nil, 4),
    FARule.new(2, 'a', 3), FARule.new(3, 'a', 2), FARule.new(4, 'a', 5),
    FARule.new(5, 'a', 6), FARule.new(6, 'a', 4)
])

# puts rulebook.next_states(Set[1], nil)
nfa_design = NFADesign.new(1, [2,4], rulebook)
puts nfa_design.accepts?('aa')
puts nfa_design.accepts?('aaa')
puts nfa_design.accepts?('aaaaa')
puts nfa_design.accepts?('aaaaaa')