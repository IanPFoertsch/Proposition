module Proposition
  class Clause < Disjunction
    #TODO: Throw exception unless initialized with only Atomic components
    #TODO: Remove duplicate sentences upon construction ie: A or A == A

    def initialize

    end

    def resolve(other)
      raise ArgumentError.new("called with argument other than #{self.class.name}") unless other.is_a?(Clause)

      hash = sentences_hash

      other.sentences.each do |sentence|
        negation = sentence.negate
        if hash[negation.in_text]
          #if our hash contains the negation,
          #remove the negation from the hash and do not add the incoming sentence
          hash[negation.in_text] = nil
        else
          hash[sentence.in_text] = sentence
        end
      end

      Clause.new(hash.values.compact)
    end

    def contains?(sentence)
      @sentences.include?(sentence)
    end

    def sentences_hash
      @sentences.inject({}) do |hash, sentence|
        hash[sentence.in_text] = sentence
        hash
      end
    end
  end
end
