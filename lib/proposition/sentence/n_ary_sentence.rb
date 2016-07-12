module Proposition
  class NArySentence < Sentence
    attr_reader :operator, :sentences

    def initialize(operator, sentences, *other_sentences)
      @operator = operator

      if sentences.is_a?(Array)
        @sentences = sentences
      else
        @sentences = [sentences] + other_sentences
      end
    end

    def in_text
      "(#{@sentences.map { |s| s.in_text }.join(' ' + @operator + ' ')})"
    end

    #a clause in propositional logic is an n-ary sentence with an OR operator
    #and only atomic components
    def is_clause?
      return false if @operator != Logic::OR

      @sentences.each do |sentence|
        return false if !sentence.is_atomic?
      end

      true
    end
  end
end
