
module Proposition
  class Sentence
    def deep_copy
      Marshal.load(Marshal.dump(self))
    end

    #TODO: Remove this is_x? booleans
    def is_atomic?
      false
    end

    def is_clause?
      false
    end

    def negate
      Not.new(self.deep_copy)
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

    def in_text
      raise NotImplementedError
    end

    def hash
      in_text.hash
    end
  end
end
