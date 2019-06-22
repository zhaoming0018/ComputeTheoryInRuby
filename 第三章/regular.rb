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
end

class Empty 
    include Pattern
    def to_s
        ''
    end

    def precedence
        3
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
end

class Concatenate < Struct.new(:first, :second)
    include Pattern

    def to_s
        [first, second].map { |pattern| pattern.bracket(precedence) }.join
    end

    def precedence
        1
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
end

class Repeat < Struct.new(:pattern)
    include Pattern

    def to_s
        pattern.bracket(precedence) + "*"
    end

    def precedence
        2
    end
end