require 'set'

class FARule < Struct.new(:state, :character, :next_state)
    def apply_to?(state, character)
        self.state == state && self.character == character
    end

    def follow
        next_state
    end

    def inspect
        "#<FARule #{state.inspect} --#{character}--> #{next_state.inspect}>"
    end
end

class DFARuleBook < Struct.new(:rules)
    def next_state(state, character)
        rule_for(state, character).follow
    end

    def rule_for(state, character)
        rules.detect {|rule| rule.apply_to?(state, character)}
    end
end

class DFA < Struct.new(:current_state, :accept_state, :rulebook)
    def accepting?
        accept_state.include?(current_state)
    end

    def read_character(character)
        self.current_state = rulebook.next_state(current_state, character)
    end

    def read_string(string)
        string.chars.each do |character|
            read_character(character)
        end
    end
end

class DFADesign < Struct.new(:start_state, :accept_state, :rulebook)
    def to_dfa
        DFA.new(start_state, accept_state, rulebook)
    end

    def accepts?(string)
        # tap方法先将对象传入区块计算，再返回这个对象（修改后）
        # 等价于：dfa = to_dfa; dfa.read_string(string); dfa
        to_dfa.tap { |dfa| dfa.read_string(string) }.accepting?
    end
end

class NFARulebook < Struct.new(:rules)
    def next_states(states, character)
        states.flat_map { |state| follow_rules_for(state, character) }.to_set
    end

    def follow_rules_for(state, character)
        rules_for(state, character).map(&:follow)
    end

    def rules_for(state, character)
        rules.select { |rule| rule.apply_to?(state, character) }
    end

    def follow_free_moves(states)
        more_states = next_states(states, nil)
        if more_states.subset?(states)
            states
        else
            follow_free_moves(states + more_states)
        end
    end
end

class NFA < Struct.new(:current_states, :accept_states, :rulebook)
    def accepting?
        (current_states & accept_states).any?
    end

    def read_character(character)
        self.current_states = rulebook.next_states(current_states, character)
    end

    def read_string(string)
        string.chars.each do |character|
            read_character(character)
        end
    end

    def current_states
        rulebook.follow_free_moves(super)
    end
end

class NFADesign < Struct.new(:start_state, :accept_states, :rulebook)
    def accepts?(string)
        to_nfa.tap { |nfa| nfa.read_string(string) }.accepting?
    end

    def to_nfa
        NFA.new(Set[start_state], accept_states, rulebook)
    end
end