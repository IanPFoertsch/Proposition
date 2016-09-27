require_relative "binary_sentence"

module Proposition
  class And < BinarySentence
    def self.compliment
      Or
    end

    def operator_symbol
      "AND"
    end

    def contains_and?
      true
    end

    def should_distribute_and?
      return @left.contains_or? || @right.contains_or?
    end

    def push_and_down
      #TODO: This is almost an exact duplicateof logic in push_or_down in the
      #or sentence class. Figure out a way to consolidate + reuse this logic
      return self unless should_distribute_and?
      #first pre-process the left and right subsentences
      if @left.should_distribute_and?
        return And.new(@left.push_and_down, @right).push_and_down
      elsif @right.should_distribute_and?
        return And.new(@left, @right.push_and_down).push_and_down
      else
        if @left.is_atomic? #base case of both atomic components caught by "should_distribute_and"
          return @right.distribute_and(left).push_and_down
        elsif @right.is_atomic?
          return rotate.push_and_down
        else # both are non-atomic, we contain an and and should distribute
          @right.distribute_and(left).push_and_down
        end
      end
    end
  end
end
