class Add < Struct.new(:left, :right)
    def reduce(environment)
        if left.reducible?
            Add.new(left.reduce(environment), right)
        elsif right.reducible?
            Add.new(left, right.reduce(environment))
        else
            Number.new(left.value + right.value)
        end
    end

    def to_s
        "#{left} + #{right}"
    end

    def reducible?
        true
    end

    def inspect
        "<<#{self}>>"
    end

    def evaluate(environment)
        Number.new(left.evaluate(environment).value + right.evaluate(environment).value)
    end

    def to_ruby
        "-> e { (#{left.to_ruby}).call(e) + (#{right.to_ruby}).call(e) }"
    end
end

class Multiply < Struct.new(:left, :right)
    def reduce(environment)
        if left.reducible?
            Multiply.new(left.reduce(environment), right)
        elsif right.reducible?
            Multiply.new(left, right.reduce(environment))
        else
            Number.new(left.value * right.value)
        end
    end

    def to_s
        "#{left} * #{right}"
    end

    def reducible?
        true
    end

    def inspect
        "<<#{self}>>"
    end

    def evaluate(environment)
        Number.new(left.evaluate(environment).value * right.evaluate(environment).value)
    end

    def to_ruby
        "-> e { (#{left.to_ruby}).call(e) * (#{right.to_ruby}).call(e) }"
    end
end

class LessThan < Struct.new(:left, :right)
    def reduce(environment)
        if left.reducible?
            LessThan.new(left.reduce(environment), right)
        elsif right.reducible?
            LessThan.new(left, right.reduce(environment))
        else
            Boolean.new(left.value < right.value)
        end
    end

    def to_s
        "#{left} < #{right}"
    end

    def reducible?
        true
    end

    def inspect
        "<<#{self}>>"
    end

    def evaluate(environment)
        Boolean.new(left.evaluate(environment).value < right.evaluate(environment).value)
    end

    def to_ruby
        "-> e { (#{left.to_ruby}).call(e) < (#{right.to_ruby}).call(e) }"
    end
end

