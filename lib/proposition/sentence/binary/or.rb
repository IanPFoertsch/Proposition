require_relative "binary_sentence"

module Proposition
  class Or < BinarySentence
    def self.compliment
      And
    end

    def push_or_down
      
    end
  end
end
