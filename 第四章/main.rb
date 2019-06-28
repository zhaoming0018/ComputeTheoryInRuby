require './PDA.rb'
require './NPDA.rb'
require './Analyzer.rb'

# rule = PDARule.new(1, '(', 2, '$', ['b', '$'])
# configuration = PDAConfiguration.new(1, Stack.new(['$']))

# puts rule.push_characters
# rule.follow(configuration)

# rulebook = DPDARulebook.new([
#     PDARule.new(1, '(', 2, '$', ['b', '$']),
#     PDARule.new(2, '(', 2, 'b', ['b', 'b']),
#     PDARule.new(2, ')', 2, 'b', []),
#     PDARule.new(2, nil, 1, '$', ['$'])
# ])

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

# rulebook = NPDARulebook.new([
#     PDARule.new(1, 'a', 1, '$', ['a', '$']),
#     PDARule.new(1, 'a', 1, 'a', ['a', 'a']),
#     PDARule.new(1, 'a', 1, 'b', ['a', 'b']),
#     PDARule.new(1, 'b', 1, '$', ['b', '$']),
#     PDARule.new(1, 'b', 1, 'a', ['b', 'a']),
#     PDARule.new(1, 'b', 1, 'b', ['b', 'b']),
#     PDARule.new(1, nil, 2, '$', ['$']),
#     PDARule.new(1, nil, 2, 'a', ['a']),
#     PDARule.new(1, nil, 2, 'b', ['b']),
#     PDARule.new(2, 'a', 2, 'a', []),
#     PDARule.new(2, 'b', 2, 'b', []),
#     PDARule.new(2, nil, 3, '$', ['$'])
# ])

# configuration = PDAConfiguration.new(1, Stack.new(['$']))
# puts configuration
# npda = NPDA.new(Set[configuration], [3], rulebook)
# puts npda.accepting?
# puts npda.current_configurations
# npda.read_string('abb')
# puts npda.accepting?
# npda.read_string('a')
# puts npda.accepting?

# npda_design = NPDADesign.new(1, '$', [3], rulebook)
# puts npda_design.accepts?('abba')
# puts npda_design.accepts?('babbbbab')
# puts npda_design.accepts?('abb')

# 语法分析实例

# 要识别<statement>,所以先推入S
start_rule = PDARule.new(1, nil, 2, '$', ['S', '$'])

symbol_rules = [
    # <statement> ::= <while> | <assign>
    PDARule.new(2, nil, 2, 'S', ['W']),
    PDARule.new(2, nil, 2, 'S', ['A']),

    #  <while> ::= 'w' '(' <expression> ')' '{' <statement> '}'
    PDARule.new(2, nil, 2, 'W', ['w', '(', 'E', ')', '{', 'S', '}']),

    # <assign> ::= 'v' '=' <expression>
    PDARule.new(2, nil, 2, 'A', ['v', '=', 'E']),

    # <expression> ::= <less-than>
    PDARule.new(2, nil, 2, 'E', ['L']),

    # <less-than> ::= <multiply> '<' <less-than> | <multiply>
    PDARule.new(2, nil, 2, 'L', ['M', '<', 'L']),
    PDARule.new(2, nil, 2, 'L', ['M']),
    
    # <multiply> ::= <term> '*' <multiply> | <term>
    PDARule.new(2, nil, 2, 'M', ['T', '*', 'M']),
    PDARule.new(2, nil, 2, 'M', ['T']),

    # <term> ::= 'n' | 'v'
    PDARule.new(2, nil, 2, 'T', ['n']),
    PDARule.new(2, nil, 2, 'T', ['v'])
]

token_rules = LexicalAnalyzer::GRAMMAR.map do |rule|
    PDARule.new(2, rule[:token], 2, rule[:token], [])
end

stop_rule = PDARule.new(2, nil, 3, '$', ['$'])

rulebook = NPDARulebook.new([start_rule, stop_rule] + symbol_rules + token_rules)

npda_design = NPDADesign.new(1, '$', [3], rulebook)

token_string = LexicalAnalyzer.new('while (x < 5) { x = x * 3 }').analyze.join

puts npda_design.accepts?(token_string)

puts npda_design.accepts?(LexicalAnalyzer.new('while (x < 5) { x = x *  }').analyze.join)