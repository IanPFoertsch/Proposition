module Proposition
  class BinarySentence
    attr_reader :left, :right

    def initialize(left, right)
      @left = left
      @right = right
    end

    def in_text
      return "(#{left.in_text} #{self.operator_symbol} #{right.in_text})"
    end

    def distribute_or(sentence)
      new_left = Or.new(sentence, @left)
      new_right = Or.new(sentence, @right)
      self.class.new(new_left, new_right)
    end

    def distribute_and(sentence)
      new_left = And.new(sentence, @left)
      new_right = And.new(sentence, @right)
      self.class.new(new_left, new_right)
    end

    def push_not_down
      return carry_operation_down(:push_not_down)
    end

    def ==(other)
      return false unless other.is_a?(self.class)
      return false unless @left == other.left
      @right == other.right
    end

    def push_or_down
      carry_operation_down(:push_or_down)
    end

    def push_and_down
      carry_operation_down(:push_and_down)
    end

    private

    def carry_operation_down(operation_symbol)
      new_left = @left.send(operation_symbol)
      new_right = @right.send(operation_symbol)
      self.class.new(new_left, new_right)
    end
  end
end
