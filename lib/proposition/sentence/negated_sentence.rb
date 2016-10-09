require_relative "sentence"

module Proposition
  #TODO: Rename this to 'Not' to follow the convention with AND/OR
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

    def push_or_down
      @sentence.distribute_not.push_or_down
    end

    def distribute_not
      @sentence
    end

    def distribute_or(sentence)
      push_not_down.distribute_or(sentence)
    end

    def distribute_and(sentence)
      push_not_down.distribute_and(sentence)
    end
  end
end
