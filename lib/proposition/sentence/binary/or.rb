module Proposition
  class Or < BinarySentence
    def compliment
      And
    end

    def operator_symbol
      "OR"
    end

    def contains_or?
      true
    end

    def to_disjunction
      left_clause = @left.to_disjunction
      right_clause = @right.to_disjunction
      left_clause.conjoin(right_clause)
    end

    def to_conjunction_of_disjunctions
      Conjunction.new([to_disjunction])
    end

    def to_conjunctive_normal_form
      push_not_down
        .push_or_down
        .to_conjunction_of_disjunctions
    end

    def should_distribute_or?
      return @left.contains_and? || @right.contains_and?
    end

    def push_or_down
      return self unless should_distribute_or?
      #TODO: Can we eliminate this tell/ask block here?
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
