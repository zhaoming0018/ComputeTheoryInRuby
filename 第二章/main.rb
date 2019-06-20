RubyVM::InstructionSequence.compile_option = {
    tailcall_optimization: true,
    trace_instruction: false
}
require './require_all.rb'
# statement = While.new(
#     LessThan.new(Variable.new(:x), Number.new(5)),
#     Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
# )
# x = statement.evaluate({x: Number.new(1)})
x = Number.new(5).to_ruby
puts x