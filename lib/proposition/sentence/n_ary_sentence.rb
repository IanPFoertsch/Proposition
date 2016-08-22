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


    def retrieve_atomic_components
      @sentences.each do |sentence|
        unless sentence.is_a?(AtomicSentence)
          raise "Retreiving Atomic Components on an N Ary Sentence containing "\
            "non-atomic components"
        end
      end
      @sentences.clone
    end

    def resolve(a_clause)
      unless self.is_clause? && a_clause.is_clause?
        raise "sentence: #{in_text} & sentence: #{a_clause.in_text} should both be clauses"
      end

      working_copy = self.deep_copy

      a_clause.sentences.each do |sentence|
        working_copy = working_copy.add_sentence(sentence)
      end

      working_copy

    end

    def add_sentence(add_me)
      if @sentences.include?(add_me.negate)
        return NArySentence.new(@operator, @sentences.clone.reject { |s| s == add_me.negate })
      elsif @sentences.include?(add_me)
        self
      else
        NArySentence.new(@operator, @sentences.clone + [add_me])
      end
    end

    def empty?
      return @sentences.empty?
    end

    def ==(other_sentence)
      return false unless other_sentence.is_a?(NArySentence)
      #TODO: This is wrong, figure out a better way to compare object equality
      return false unless in_text == other_sentence.in_text
      true

    end
  end
end
