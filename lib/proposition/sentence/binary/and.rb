require_relative "binary_sentence"

module Proposition
  class And < BinarySentence
    def self.compliment
      Or
    end
  end
end
