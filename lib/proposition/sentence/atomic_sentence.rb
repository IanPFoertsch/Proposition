
require_relative "n_ary/clause"

module Proposition
  class AtomicSentence < Sentence
    attr_reader :symbol, :truth, :operator

    def initialize(input, operator=nil)
      if input.is_a? String
        @symbol = input
      elsif (input.is_a? TrueClass) || (input.is_a? FalseClass)
        @truth = input
      else
        raise Exception.new("Atomic Sentence initialized with non String, non boolean argument")
      end
      @operator = operator
    end

    def is_unary?
      true
    end

    def is_atomic?
      true
    end

    def deep_copy
      Marshal.load(Marshal.dump(self))
    end

    def negate
      if !@truth.nil?
        AtomicSentence.new(!@truth)
      else
        operator = @operator ? nil : Logic::NOT
        AtomicSentence.new(@symbol, operator)
      end
    end

    def ==(other)
      return false unless other.is_a?(AtomicSentence)
      if ( @symbol == other.symbol &&
        @truth == other.truth &&
        @operator == other.operator )
        true
      else
        false
      end
    end

    def in_text
      "#{@operator ? @operator + ' ' : ''}#{@symbol ? @symbol : ''}#{!@truth.nil? ? @truth : ''}"
    end

    def push_not_down
      return self
    end

    def push_or_down
      self
    end

    def push_and_down
      self
    end

    def retrieve_atomic_components
      [self]
    end

    def no_complex_operations?
      return true
    end

    def eliminate_operator(operator)
      if operator == Logic::AND || operator == Logic::NOT
        raise "eliminate_operator called for AND or OR, should only be used for
          XOR, IMPLICATION, or BICONDITIONAL"
      end
      return self
    end

    def push_operator_down(operator)
      return self
    end

    def to_disjunction
      Clause.new([self])
    end

    def atomic_components
      self
    end

    def contains_operator?(operator)
      return !@operator.nil? && @operator == operator && operator == Logic::NOT
    end

    def to_conjunction_of_disjunctions
      Conjunction.new([to_disjunction])
    end
  end
end
