
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
  end
end
