
module Proposition
  class Sentence
    def deep_copy
      Marshal.load(Marshal.dump(self))
    end

    def is_atomic?
      false
    end

    def is_compound?
      false
    end

    def is_clause?
      false
    end

    def negate
      NegatedSentence.new(self.deep_copy)
    end

    def contains_or?
      false
    end

    def contains_and?
      false
    end

    def should_distribute_or?
      false
    end

    def should_distribute_and?
      false
    end
  end
end
