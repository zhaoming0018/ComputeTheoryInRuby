require './TM.rb'

tape = Tape.new(['1', '0', '1'], '1', [], '_')
puts tape

# puts tape.move_head_left
# puts tape.write('0')
# puts tape.move_head_right
# puts tape.move_head_right.write('0')

# rule = TMRule.new(1, '0', 2, '1', :right)
# puts rule

# puts rule.applies_to?(TMConfiguration.new(1, Tape.new([], '0', [], '_')))
# puts rule.applies_to?(TMConfiguration.new(1, Tape.new([], '1', [], '_')))

# puts rule.follow(TMConfiguration.new(1, Tape.new([], '0', [], '_')))

rulebook = DTMRulebook.new([
    TMRule.new(1, '0', 2, '1', :right),
    TMRule.new(1, '1', 1, '0', :left),
    TMRule.new(1, '_', 2, '1', :right),
    TMRule.new(2, '0', 2, '0', :right),
    TMRule.new(2, '1', 2, '1', :right),
    TMRule.new(2, '_', 3, '_', :left)
])

# configuration = TMConfiguration.new(1, tape)
# puts configuration
# configuration = rulebook.next_configuration(configuration)
# puts configuration
# configuration = rulebook.next_configuration(configuration)
# puts configuration
# configuration = rulebook.next_configuration(configuration)
# puts configuration
# configuration = rulebook.next_configuration(configuration)
# puts configuration

dtm = DTM.new(TMConfiguration.new(1, tape), [3], rulebook)
puts dtm.current_configuration
puts dtm.accepting?
dtm.step
puts dtm.current_configuration

dtm.run 
puts dtm.current_configuration
puts dtm.accepting?

tape = Tape.new(['1', '2', '1'], '1', [], '_')
dtm = DTM.new(TMConfiguration.new(1, tape), [3], rulebook)
dtm.run
puts dtm.current_configuration
puts dtm.accepting?
puts dtm.stuck?


rulebook = DTMRulebook.new([
    # state 1: scan right looking for a
    TMRule.new(1, 'X', 1, 'X', :right),
    TMRule.new(1, 'a', 2, 'X', :right),
    TMRule.new(1, '_', 6, '_', :left),

    # state 2: scan right looking for b
    TMRule.new(2, 'a', 2, 'a', :right),
    TMRule.new(2, 'X', 2, 'X', :right),
    TMRule.new(2, 'b', 3, 'X', :right),

    # state 3: scan right looking for c
    TMRule.new(3, 'b', 3, 'b', :right),
    TMRule.new(3, 'X', 3, 'X', :right),
    TMRule.new(3, 'c', 4, 'X', :right),

    # state 4: scan right looking for end of string
    TMRule.new(4, 'c', 4, 'c', :right),
    TMRule.new(4, '_', 5, '_', :left),

    # state 5: scan left looking for beginning of string
    TMRule.new(5, 'a', 5, 'a', :left),
    TMRule.new(5, 'b', 5, 'b', :left),
    TMRule.new(5, 'c', 5, 'c', :left),
    TMRule.new(5, 'X', 5, 'X', :left),
    TMRule.new(5, '_', 1, '_', :right)
])

tape = Tape.new([], 'a', ['a', 'a', 'b', 'b', 'b', 'c', 'c', 'c'], '_')
puts tape

dtm = DTM.new(TMConfiguration.new(1, tape), [6], rulebook)

10.times {dtm.step}
puts dtm.current_configuration
25.times {dtm.step}
puts dtm.current_configuration

dtm.run
puts dtm.current_configuration