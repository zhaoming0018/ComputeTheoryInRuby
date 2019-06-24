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
end