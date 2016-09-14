module Proposition
  class UnarySentence < Sentence

    attr_reader :sentence

    def initialize(sentence)
      @sentence = sentence
    end

    def in_text
      return "NOT #{@sentence.in_text}"
    end

    def ==(other)
      return false unless other.is_a?(UnarySentence)
      return @sentence == other.sentence
    end

    def negate
      return @sentence.deep_copy
    end

    def push_not_down
      @sentence.distribute_not
    end
  end
end
