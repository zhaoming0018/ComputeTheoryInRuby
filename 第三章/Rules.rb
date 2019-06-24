require 'set'

# 有限自动机的（一条）规则，包含三个参数：
#   state : 当前状态
#   character : 读入的字符
#   next_state : 进入的下一个状态
class FARule < Struct.new(:state, :character, :next_state)
    # 判断对给定的state和character能否应用这个规则
    def apply_to?(state, character)
        self.state == state && self.character == character
    end

    # 获取下一个状态，一般在apply_to?为true后执行
    def follow
        next_state
    end

    def inspect
        "#<FARule #{state.inspect} --#{character}--> #{next_state.inspect}>"
    end
end

# 确定有限自动机的规则本
#   rules : 给定的规则列表（多个规则）
class DFARuleBook < Struct.new(:rules)
    # 返回下一个规则，确定有限自动机一般有且只有一条规则适应
    def next_state(state, character)
        rule_for(state, character).follow
    end

    # 找出当前状态为state，读入字符为character的规则
    def rule_for(state, character)
        # detect返回区块内验证为true的第一个元素
        rules.detect {|rule| rule.apply_to?(state, character)}
    end
end

# 确定有限自动机类，接受三个参数：
#   current_state : 当前状态，指起始状态，DFA只有一个
#   accept_states : 接受状态，可以有多个
class DFA < Struct.new(:current_state, :accept_states, :rulebook)

    # 用于检测当前状态是否为接受态
    def accepting?
        accept_states.include?(current_state)
    end

    # 读取一个字符，此时current_state将会改变
    def read_character(character)
        self.current_state = rulebook.next_state(current_state, character)
    end

    # 读取字符串，这相当于依次读取一连串字符
    def read_string(string)
        string.chars.each do |character|
            read_character(character)
        end
    end
end

# DFA设计类，可以方便的生成一个独立的DFA，接受的参数与DFA类相同
class DFADesign < Struct.new(:start_state, :accept_states, :rulebook)
    # 产生一个DFA
    def to_dfa
        DFA.new(start_state, accept_states, rulebook)
    end

    # 产生一个DFA并判定其是否接受输入的字符串
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

    def alphabet
        rules.map(&:character).compact.uniq
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

    def to_nfa(current_states = Set[start_state])
        NFA.new(current_states, accept_states, rulebook)
    end
end

class NFASimulation < Struct.new(:nfa_design)
    def next_state(state, character)
        nfa_design.to_nfa(state).tap { |nfa|
            nfa.read_character(character)
        }.current_states
    end

    def rules_for(state)
        nfa_design.rulebook.alphabet.map { |character|
            FARule.new(state, character, next_state(state, character))
        }
    end

    def discover_states_and_rules(states)
        rules =  states.flat_map { |state| rules_for(state) }
        more_states = rules.map(&:follow).to_set
        if more_states.subset?(states)
            [states, rules]
        else
            discover_states_and_rules(states + more_states)
        end
    end

    def to_dfa_design
        start_state = nfa_design.to_nfa.current_states
        states, rules = discover_states_and_rules(Set[start_state])
        accept_states = states.select { |state| nfa_design.to_nfa(state).accepting? }
        
        DFADesign.new(start_state, accept_states, DFARuleBook.new(rules))
    end
end