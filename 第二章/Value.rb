class Number < Struct.new(:value)
    def to_s
        value.to_s
    end

    def reducible?
        false
    end

    def inspect
        "<<#{self}>>"
    end

    def evaluate(environment)
        self
    end

    def to_ruby
        "-> e { #{value.inspect} }"
    end
end

class Boolean < Struct.new(:value)
    def to_s
        value.to_s
    end

    def inspect
        "<<#{self}>>"
    end

    def reducible?
        false
    end

    def evaluate(environment)
        self
    end

    def to_ruby
        "-> e { #{value.inspect} }"
    end
end

class Variable < Struct.new(:name)
    def to_s
        name.to_s
    end

    def reducible?
        true
    end

    def inspect
        "<<#{self}>>"
    end

    # Machine类会传入environment字典变量，这样对于变量，
    # 我们就可以直接用字典中的值代替了
    def reduce(environment)
        environment[name]
    end

    def evaluate(environment)
        environment[name]
    end

    def to_ruby
        "-> e { e[#{name.inspect}] }"
    end
end