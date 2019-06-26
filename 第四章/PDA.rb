# 栈， contents参数用于表示当前栈中内容
# 初始的时候，栈中内容为['$']
class Stack < Struct.new(:contents)
    # 返回添加一个元素后的栈
    def push(character)
        Stack.new([character] + contents)
    end

    # 返回弹出一个元素后的栈
    def pop
        Stack.new(contents.drop(1))
    end

    # 获取当前栈中的顶端元素
    def top
        contents.first
    end

    def inspect
        "#<Stack (#{top})#{contents.drop(1).join}>"
    end
end

# 定义一个结构，记录PDA的两个组成元素：
#   state : 当前所处的状态
#   stack : 当前栈的状态
class PDAConfiguration < Struct.new(:state, :stack)
    STUCK_STATE = Object.new

    def stuck
        PDAConfiguration.new(STUCK_STATE, stack)
    end

    def stuck?
        state == STUCK_STATE
    end
end

# 记录一条PDA转移的规则
#   state : 当前状态
#   character : 读入字符
#   next_state : 下一个状态
#   pop_character : 弹出栈中的内容
#   push_character : 推入栈中的内容
class PDARule < Struct.new(:state, :character, :next_state, :pop_character, :push_characters)
    # 判断能否试用此规则
    # 要求当前状态一致，需要弹出栈的顶端元素一致和读入的字符一致
    def applies_to?(configuration, character)
        self.state == configuration.state &&
        self.pop_character == configuration.stack.top &&
        self.character == character
    end

    def follow(configuration)
        PDAConfiguration.new(next_state, next_stack(configuration))
    end

    def next_stack(configuration)
        popped_stack = configuration.stack.pop
        
        push_characters.reverse.inject(popped_stack) { |stack, character|
            stack.push(character)
        }
    end
end

class DPDARulebook < Struct.new(:rules)
    def next_configuration(configuration, character)
        rule_for(configuration, character).follow(configuration)
    end

    def rule_for(configuration, character)
        rules.detect { |rule| rule.applies_to?(configuration, character)}
    end

    def applies_to?(configuration, character)
        !rule_for(configuration, character).nil?
    end

    def follow_free_moves(configuration)
        if applies_to?(configuration, nil)
            follow_free_moves(next_configuration(configuration, nil))
        else
            configuration
        end
    end
end

class DPDA < Struct.new(:current_configuration, :accept_states, :rulebook)
    def accepting?
        accept_states.include?(current_configuration.state)
    end

    def read_character(character)
        self.current_configuration = next_configuration(character)
    end

    def read_string(string)
        string.chars.each do |character|
            read_character(character) unless  stuck?
        end
    end

    def current_configuration
        rulebook.follow_free_moves(super)
    end

    def next_configuration(character)
        if rulebook.applies_to?(current_configuration, character)
            rulebook.next_configuration(current_configuration, character)
        else
            current_configuration.stuck
        end
    end

    def stuck?
        current_configuration.stuck?
    end
end

class DPDADesign < Struct.new(:start_state, :bottom_character, :accept_states, :rulebook)
    def accepts?(string)
        to_dpda.tap { |dpda| dpda.read_string(string) }.accepting?
    end

    def to_dpda
        start_stack = Stack.new([bottom_character])
        start_configuration = PDAConfiguration.new(start_state, start_stack)
        DPDA.new(start_configuration, accept_states, rulebook)
    end
end