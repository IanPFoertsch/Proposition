module Proposition
  class NegatedSentence < Sentence

    attr_reader :sentence


    def initialize(sentence)
      @sentence = sentence
    end

    def in_text
      return "NOT #{@sentence.in_text}"
    end

    def ==(other)
      return false unless other.is_a?(NegatedSentence)
      return @sentence == other.sentence
    end

    def negate
      return @sentence.deep_copy
    end

    def push_not_down
      @sentence.distribute_not.push_not_down
    end

    def eliminate_operator(operator)
      NegatedSentence.new(@sentence.eliminate_operator(operator))
    end

    def distribute(sentence, operator)
      push_not_down.distribute(sentence, operator)
    end

    def is_unary?
      true
    end
  end
end
