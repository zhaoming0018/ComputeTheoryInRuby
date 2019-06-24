require './Rules.rb'
module Pattern
    def bracket(outer_precedence)
        # 如果自己的优先级低于外层的优先级，就加上括号
        # 如：Literal的优先级3高于连接1，则不需要括号=>连接a和b，为ab
        # 如：选择的优先级0低于连接的优先级1，则不需要括号=>选择ab和b，为ab|b
        # 如：选择的优先级0低于重复2，则加括号=>重复ab|b，为(ab|b)*
        if precedence < outer_precedence
            '(' + to_s + ')'
        else
            to_s
        end
    end

    def inspect
        "/#{self}/"
    end

    def matches?(string)
        to_nfa_design.accepts?(string)
    end
end

class Empty 
    include Pattern
    def to_s
        ''
    end

    def precedence
        3
    end

    def to_nfa_design
        start_state = Object.new
        accept_states = [start_state]
        rulebook = NFARulebook.new([])

        NFADesign.new(start_state, accept_states, rulebook)
    end
end

class Literal < Struct.new(:character)
    include Pattern
    
    def to_s
        character
    end

    def precedence
        3
    end

    def to_nfa_design
        start_state = Object.new
        accept_state = Object.new
        rule = FARule.new(start_state, character, accept_state)
        rulebook = NFARulebook.new([rule])

        NFADesign.new(start_state, [accept_state], rulebook)
    end
end

class Concatenate < Struct.new(:first, :second)
    include Pattern

    def to_s
        [first, second].map { |pattern| pattern.bracket(precedence) }.join
    end

    def precedence
        1
    end

    def to_nfa_design
        first_nfa_design = first.to_nfa_design
        second_nfa_design = second.to_nfa_design

        start_state = first_nfa_design.start_state
        accept_states = second_nfa_design.accept_states
        rules = first_nfa_design.rulebook.rules + second_nfa_design.rulebook.rules
        extra_rules = first_nfa_design.accept_states.map { |state|
            FARule.new(state, nil, second_nfa_design.start_state)
        }

        rulebook = NFARulebook.new(rules + extra_rules)
        NFADesign.new(start_state, accept_states, rulebook)
    end
end

class Choose < Struct.new(:first, :second)
    include Pattern

    def to_s
        [first, second].map { |pattern| pattern.bracket(precedence) }.join('|')
    end

    def precedence
        0
    end

    def to_nfa_design
        first_nfa_design = first.to_nfa_design
        second_nfa_design = second.to_nfa_design

        start_state = Object.new
        accept_states = first_nfa_design.accept_states + second_nfa_design.accept_states
        rules = first_nfa_design.rulebook.rules + second_nfa_design.rulebook.rules
        extra_rules = [first_nfa_design, second_nfa_design].map { |nfa_desgin|
            FARule.new(start_state, nil, nfa_desgin.start_state)
        }
        rulebook = NFARulebook.new(rules + extra_rules)
        NFADesign.new(start_state, accept_states, rulebook)
    end
end

class Repeat < Struct.new(:pattern)
    include Pattern

    def to_s
        pattern.bracket(precedence) + "*"
    end

    def precedence
        2
    end

    def to_nfa_design
        pattern_nfa_design = pattern.to_nfa_design

        start_state = Object.new
        accept_states = pattern_nfa_design.accept_states + [start_state]
        rules = pattern_nfa_design.rulebook.rules
        extra_rules = 
            pattern_nfa_design.accept_states.map { |accept_state|
                FARule.new(accept_state, nil, pattern_nfa_design.start_state)
            } +
            [FARule.new(start_state, nil, pattern_nfa_design.start_state)]
        rulebook = NFARulebook.new(rules + extra_rules)

        NFADesign.new(start_state, accept_states, rulebook)
    end
end