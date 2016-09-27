require_relative "binary_sentence"

module Proposition
  class Or < BinarySentence
    def self.compliment
      And
    end

    def operator_symbol
      "OR"
    end

    def contains_or?
      true
    end


    def should_distribute_or?
      return @left.contains_and? || @right.contains_and?
    end

    def push_or_down
      return self unless should_distribute_or?
      #first pre-process the left and right subsentences
      if @left.should_distribute_or?
        return Or.new(@left.push_or_down, @right).push_or_down
      elsif @right.should_distribute_or?
        return Or.new(@left, @right.push_or_down).push_or_down
      else
        if @left.is_atomic? #base case of both atomic components caught by "should_distribute_or"
          return @right.distribute_or(left).push_or_down
        elsif @right.is_atomic?
          return rotate.push_or_down
        else # both are non-atomic, we contain an or and should distribute
          @right.distribute_or(left).push_or_down
        end
      end
    end
  end
end
